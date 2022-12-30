# Pure julia USAGE
#
# julia -- julia2nix.jl "pkg1" "pkg2" ...

using Pkg
using Pkg.Artifacts
using SHA

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

function pkg_nix(name, version, uuid, tree_hash, deps)
    server = pkg_server()
    julia_pname = "julia-bin"
    julia_version = Base.VERSION
    # sha256 = "$(pkg_sha256(uuid, tree_hash))";
    nix = """
        {
            pname = "$(name)";
            version = "$(version)";
            src = fetchurl {
                url = "$(pkg_url(uuid, tree_hash))";
                name = "$(julia_pname)-$(julia_version)-$(name)-$(version).tar.gz";
                sha256 = "$(pkg_sha256(uuid, tree_hash))";
            };$(if deps != "" "\n        " * deps else "" end)
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
    artifacts = select_downloadable_artifacts(artifacts_toml)
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
    println("[")
    for uuid in keys(pkgs)
        haskey(stdlibs, uuid) && continue
        pkg = pkgs[uuid]
        artifact_names, artifact_nixes = artifacts_nix(pkg)
        deps = [artifact_names; collect(keys(filter_stdlib_pkgs(pkg.dependencies)))]
        println(pkg_nix(pkg.name, pkg.version, uuid, pkg.tree_hash, deps_str(deps)))
        for art in artifact_nixes
            println(art)
        end
    end
    println("]")
end

###################################################################
# Main part

function main()
    pkgs = parse_args()
    produce_nix_definitions(pkgs)
end

function print_usage()
    println("""
    julia2nix [--help] pkg ...

    Print to stdout a 'nix' list of expressions for packages 'pkg ...' end their
    dependencies suitable for importing into a nix Julia environment.

    OPTIONS
    --help  Print this message
    """)
end

function parse_args(args = Base.ARGS)
    if length(args) == 0 || args[1] == "--help"
        print_usage()
        exit(0)
    end
    pkgs = map(a -> PackageSpec(name = a), Base.ARGS) ::Vector{PackageSpec}
    return pkgs
end

function produce_nix_definitions(pkgs)
    popfirst!(DEPOT_PATH)
    path = mktempdir(prefix="julia2nix_")
    pushfirst!(DEPOT_PATH, path)
    push!(LOAD_PATH, path * "/packages")
    ENV["JULIA_PKG_PRECOMPILE_AUTO"]=0

    try
        Pkg.activate(path)
        Pkg.Registry.add()

        Pkg.add(pkgs)
        pkgs_deps = Pkg.dependencies()
        nix_pkg_defs(pkgs_deps)
    catch
        @error "One or more packages not found, check the names."
        exit(1)
    end
end

main()
