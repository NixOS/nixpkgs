using Pkg
using Pkg.Artifacts: select_downloadable_artifacts
using SHA: sha256
using Base.Filesystem: isfile, cp
using ArgParse

###################################################################
# Help functions

stdlibs = Pkg.Types.get_last_stdlibs(Base.VERSION)

function pkg_server()
    return "https://pkg.julialang.org"
end

function pkg_url(uuid, tree_hash)
    return pkg_server() * "/package/$(uuid)/$(tree_hash)"
end

function pkg_sha256(uuid, tree_hash)
    path = download(pkg_url(uuid, tree_hash))
    calc_hash = open(path) do file
        bytes2hex(sha256(file))
    end
    return calc_hash
end

function deps_str(deps)
    if isempty(deps)
        return ""
    else
        ds = "[ "
        for d in deps
            ds = ds * string(d) * " "
        end
        ds = ds * "];"
        return "requiredJuliaPackages = " * ds
    end
end

function pkg_slug(uuid, tree_hash)
    return Base.version_slug(uuid, Base.SHA1((tree_hash)))
end

function pkg_nix(name, version, uuid, tree_hash, deps)
    server = pkg_server()
    julia_pname = "julia-bin"
    julia_version = Base.VERSION
    path = name * "/" *  pkg_slug(uuid, tree_hash);
    nix = """
        {
            pname = "$(name)";
            version = "$(version)";
            src = fetchurl {
                url = "$(pkg_url(uuid, tree_hash))";
                name = "$(julia_pname)-$(julia_version)-$(name)-$(version).tar.gz";
                sha256 = "$(pkg_sha256(uuid, tree_hash))";
            };
            juliaPath = "$(path)";$(if deps != "" "\n        " * deps else "" end)
        }
    """
    return nix
end

function filter_stdlib_pkgs(deps::Dict{String, Base.UUID})
    fdeps = Dict(deps)
    for name in keys(fdeps)
        if haskey(stdlibs, fdeps[name])
            delete!(fdeps, name)
        end
    end
    return fdeps
end

function  artifacts_nix(pkg)
    artifacts_toml = joinpath(pkg.source, "Artifacts.toml")
    artifacts = select_downloadable_artifacts(artifacts_toml, include_lazy=true)
    server = pkg_server()
    julia_pname = "julia-bin"
    julia_version = Base.VERSION
    nixes = []
    artifact_names = []
    for name in keys(artifacts)
        artifact = artifacts[name]
        tree_hash = artifact["git-tree-sha1"]
        # XXX FIXME: an artifact can have more than 1 download XXX
        url = artifact["download"][1]["url"]
        sha256 = artifact["download"][1]["sha256"]
        artifact_full_name = "$(pkg.name)-$(name)"
        nix = """
            {
                pname = "$(artifact_full_name)";
                version = "$(pkg.version)";
                src = fetchurl {
                    url = "$(url)";
                    name = "$(julia_pname)-$(julia_version)-$(artifact_full_name)-$(pkg.version).tar.gz";
                    sha256 = "$(sha256)";
                };
                isJuliaArtifact = true;
                juliaPath = "$(tree_hash)";
            }
        """
        artifact_names = [artifact_names; [artifact_full_name]]
        nixes = [nixes; [nix]]
    end
    return (artifact_names, nixes)
end

function nix_pkg_defs(pkgs)
    result = "["
    for uuid in keys(pkgs)
        haskey(stdlibs, uuid) && continue
        pkg = pkgs[uuid]
        artifact_names, artifact_nixes = artifacts_nix(pkg)
        deps = [artifact_names; collect(keys(filter_stdlib_pkgs(pkg.dependencies)))]
        result = result * "\n" * pkg_nix(pkg.name, pkg.version, uuid, pkg.tree_hash, deps_str(deps))
        for art in artifact_nixes
            result = result * "\n" * art
        end
    end
    return result * "]"
end

###################################################################
# Find packages info

function julia_init()
    popfirst!(DEPOT_PATH)
    path = mktempdir(prefix="julia2nix_")
    pushfirst!(DEPOT_PATH, path)
    push!(LOAD_PATH, path * "/packages")
    ENV["JULIA_PKG_PRECOMPILE_AUTO"]=0
    return path
end

function nix_definitions_from_pkgs_names(args)
    path = julia_init()
    try
        pkgs = map(p -> Pkg.REPLMode.parse_package(Pkg.REPLMode.lex(p), ())[1], args)
        Pkg.activate(path)
        Pkg.Registry.add()
        Pkg.offline(false)
        Pkg.add(pkgs)
        pkgs_deps = Pkg.dependencies()
        return nix_pkg_defs(pkgs_deps)
    catch e
        if isa(e, Exception)
            Base.showerror(stderr, e)
        else
            println(stderr, "One or more packages or package versions not found.")
        end
        exit(1)
    end
end

function nix_definitions_from_project_toml(ptoml)
    path = julia_init()
    try
        Pkg.Registry.add()
        # if there's no Manifest.toml file copy Project.toml to a writable
        # tmp dir and generate it.
        if !isfile(dirname(ptoml) * "/Manifest.toml")
            ptoml_tmp = path * "/" * basename(ptoml)
            cp(ptoml, ptoml_tmp)
            Pkg.activate(ptoml_tmp)
            Pkg.resolve()
        else
            Pkg.activate(ptoml)
        end
        pkgs_deps = Pkg.dependencies()
        return nix_pkg_defs(pkgs_deps)
    catch e
        if isa(e, PkgError)
            Base.showerror(stderr, e)
        else
            println(stderr, "Error processing $(ptoml).")
        end
        exit(1)
    end
end

#######################################################################
# Parse args

function parse_commandline() description = """ Generate a 'nix' list
    of expressions for packages 'pkg...'  end their dependencies
    suitable for importing into nixpkgs. If the '--project' option is
    used then produce definitions for the packages in Project.toml
    (inc.  dependencies).  By default the output is sent to stdout. If
    the option '-o' is specified then the output is sent to FILE
    instead."""

    s = ArgParseSettings(description = description, version = "0.1.0", add_version = true)

    @add_arg_table s begin
        "--project", "-p"
        help = "Packages from the Project.toml file"
        arg_type = String
        metavar = "Project.toml"
        "--output", "-o"
        help = "Output file name."
        arg_type = String
        metavar = "FILE"
        "--function", "-f"
        help = "Output a function rather than an array"
        nargs = 0
        "pkg"
        help = "Julia package name"
        nargs = '*'
        arg_type = String
    end

    return parse_args(s)
end

#######################################################################
# Safe IO

function with_file(filename, f)
    if isnothing(filename)
        f(stdout)
    else
        if isfile(filename)
            println("File $(filename) exists. Overwrite? ([y]/n)")
            answer = readline()
            while answer != "y" && answer != "n" && answer != ""
                println("Please answer 'y' or 'n'.")
                answer = readline()
            end
            if answer != "y" return end
        end
        try
            open(filename, "w") do io
                f(io)
            end
        catch e
            showerror(stderr, e)
        end
    end
end

#######################################################################
# Main

function nix_function_header()
    return "{ juliaPkgs, fetchurl }:\n\nwith juliaPkgs;\n\n"
end

function main()
    parsed_args = parse_commandline()
    file_name =  parsed_args["output"] # nothing if not specified

    # handle "--project"
    ptoml = parsed_args["project"] # nothing if not specified
    pkgs = if isnothing(ptoml)
        nix_definitions_from_pkgs_names(parsed_args["pkg"])
    else
        nix_definitions_from_project_toml(ptoml)
    end

    if isnothing(parsed_args["output"])
        if parsed_args["function"]
            println(nix_function_header() * pkgs)
        else
            println(pkgs)
        end
    else
        with_file(file_name, io ->
            if parsed_args["function"]
                println(io, nix_function_header() * pkgs)
            else
                println(io, pkgs)
        end)
    end
end

main()
