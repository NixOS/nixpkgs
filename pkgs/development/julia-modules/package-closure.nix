{
  lib,
  julia,
  python3,
  runCommand,

  augmentedRegistry,
  packageNames,
  packageOverrides,
  packageImplications,
}:

let
  juliaExpression = packageNames: ''
    import Pkg
    Pkg.Registry.add(Pkg.RegistrySpec(path="${augmentedRegistry}"))

    import Pkg.Types: Context, PackageSpec

    input = ${lib.generators.toJSON { } packageNames}

    if isfile("extra_package_names.txt")
        append!(input, readlines("extra_package_names.txt"))
    end

    input = unique(input)

    println("Resolving packages: " * join(input, " "))

    pkgs = [PackageSpec(pkg) for pkg in input]

    ctx = Context()

    overrides = Dict{String, String}(${
      builtins.concatStringsSep ", " (
        lib.mapAttrsToList (name: path: ''"${name}" => "${path}"'') packageOverrides
      )
    })
    ${builtins.readFile ./resolve_packages.jl}

    open(ENV["out"], "w") do io
        for spec in pkgs
            println(io, "- name: " * spec.name)
            println(io, "  uuid: " * string(spec.uuid))
            println(io, "  version: " * string(spec.version))
            println(io, "  tree_hash: " * string(spec.tree_hash))
            if endswith(spec.name, "_jll") && haskey(deps_map, spec.uuid)
                println(io, "  depends_on: ")
                for (dep_name, dep_uuid) in pairs(deps_map[spec.uuid])
                    println(io, "    \"$(dep_name)\": \"$(dep_uuid)\"")
                end
            end
            println(io, "  deps: ")
            for (dep_name, dep_uuid) in pairs(deps_map[spec.uuid])
                println(io, "  - name: \"$(dep_name)\"")
                println(io, "    uuid: \"$(dep_uuid)\"")
            end
            if spec.name in input
                println(io, "  is_input: true")
            end
        end
    end
  '';
in

runCommand "julia-package-closure.yml"
  {
    buildInputs = [
      julia
      (python3.withPackages (ps: with ps; [ pyyaml ]))
    ];
  }
  ''
    mkdir home
    export HOME=$(pwd)/home

    echo "Resolving Julia packages with the following inputs"
    echo "Julia: ${julia}"
    echo "Registry: ${augmentedRegistry}"

    # Prevent a warning where Julia tries to download package server info
    export JULIA_PKG_SERVER=""

    julia -e '${juliaExpression packageNames}';

    # See if we need to add any extra package names based on the closure
    # and the packageImplications
    python ${./python}/find_package_implications.py "$out" '${
      lib.generators.toJSON { } packageImplications
    }' extra_package_names.txt

    if [ -f extra_package_names.txt ]; then
      echo "Re-resolving with additional package names"
      julia -e '${juliaExpression packageNames}';
    fi
  ''
