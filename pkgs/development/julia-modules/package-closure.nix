{ lib
, julia
, python3
, runCommand

, augmentedRegistry
, packageNames
, packageOverrides
, packageImplications
}:

let
  # The specific package resolution code depends on the Julia version
  # These are pretty similar and could be combined to reduce duplication
  resolveCode = if lib.versionOlder julia.version "1.7" then resolveCode1_6 else resolveCode1_8;

  resolveCode1_6 = ''
    import Pkg.API: check_package_name
    import Pkg.Types: Context!, PRESERVE_NONE, manifest_info, project_deps_resolve!, registry_resolve!, stdlib_resolve!, ensure_resolved
    import Pkg.Operations: _resolve, assert_can_add, is_dep, update_package_add

    foreach(pkg -> check_package_name(pkg.name, :add), pkgs)
    pkgs = deepcopy(pkgs)  # deepcopy for avoid mutating PackageSpec members
    Context!(ctx)

    project_deps_resolve!(ctx, pkgs)
    registry_resolve!(ctx, pkgs)
    stdlib_resolve!(pkgs)
    ensure_resolved(ctx, pkgs, registry=true)

    assert_can_add(ctx, pkgs)

    for (i, pkg) in pairs(pkgs)
        entry = manifest_info(ctx, pkg.uuid)
        pkgs[i] = update_package_add(ctx, pkg, entry, is_dep(ctx, pkg))
    end

    foreach(pkg -> ctx.env.project.deps[pkg.name] = pkg.uuid, pkgs)

    pkgs, deps_map = _resolve(ctx, pkgs, PRESERVE_NONE)
'';

  resolveCode1_8 = ''
    import Pkg.API: handle_package_input!
    import Pkg.Types: PRESERVE_NONE, project_deps_resolve!, registry_resolve!, stdlib_resolve!, ensure_resolved
    import Pkg.Operations: _resolve, assert_can_add, update_package_add

    foreach(handle_package_input!, pkgs)

    # The handle_package_input! call above clears pkg.path, so we have to apply package overrides after
    overrides = Dict{String, String}(${builtins.concatStringsSep ", " (lib.mapAttrsToList (name: path: ''"${name}" => "${path}"'') packageOverrides)})
    println("Package overrides: ")
    println(overrides)
    for pkg in pkgs
      if pkg.name in keys(overrides)
        pkg.path = overrides[pkg.name]
      end
    end

    project_deps_resolve!(ctx.env, pkgs)
    registry_resolve!(ctx.registries, pkgs)
    stdlib_resolve!(pkgs)
    ensure_resolved(ctx, ctx.env.manifest, pkgs, registry=true)

    assert_can_add(ctx, pkgs)

    for (i, pkg) in pairs(pkgs)
        entry = Pkg.Types.manifest_info(ctx.env.manifest, pkg.uuid)
        is_dep = any(uuid -> uuid == pkg.uuid, [uuid for (name, uuid) in ctx.env.project.deps])
        pkgs[i] = update_package_add(ctx, pkg, entry, is_dep)
    end

    foreach(pkg -> ctx.env.project.deps[pkg.name] = pkg.uuid, pkgs)

    # Save the original pkgs for later. We might need to augment it with the weak dependencies
    orig_pkgs = pkgs

    pkgs, deps_map = _resolve(ctx.io, ctx.env, ctx.registries, pkgs, PRESERVE_NONE, ctx.julia_version)

    if VERSION >= VersionNumber("1.9")
        while true
            # Check for weak dependencies, which appear on the RHS of the deps_map but not in pkgs.
            # Build up weak_name_to_uuid
            uuid_to_name = Dict()
            for pkg in pkgs
                uuid_to_name[pkg.uuid] = pkg.name
            end
            weak_name_to_uuid = Dict()
            for (uuid, deps) in pairs(deps_map)
                for (dep_name, dep_uuid) in pairs(deps)
                    if !haskey(uuid_to_name, dep_uuid)
                        weak_name_to_uuid[dep_name] = dep_uuid
                    end
                end
            end

            if isempty(weak_name_to_uuid)
                break
            end

            # We have nontrivial weak dependencies, so add each one to the initial pkgs and then re-run _resolve
            println("Found weak dependencies: $(keys(weak_name_to_uuid))")

            orig_uuids = Set([pkg.uuid for pkg in orig_pkgs])

            for (name, uuid) in pairs(weak_name_to_uuid)
                if uuid in orig_uuids
                    continue
                end

                pkg = PackageSpec(name, uuid)

                push!(orig_uuids, uuid)
                push!(orig_pkgs, pkg)
                ctx.env.project.deps[name] = uuid
                entry = Pkg.Types.manifest_info(ctx.env.manifest, uuid)
                orig_pkgs[length(orig_pkgs)] = update_package_add(ctx, pkg, entry, false)
            end

            global pkgs, deps_map = _resolve(ctx.io, ctx.env, ctx.registries, orig_pkgs, PRESERVE_NONE, ctx.julia_version)
        end
    end
  '';

  juliaExpression = packageNames: ''
    import Pkg
    Pkg.Registry.add(Pkg.RegistrySpec(path="${augmentedRegistry}"))

    import Pkg.Types: Context, PackageSpec

    input = ${lib.generators.toJSON {} packageNames}

    if isfile("extra_package_names.txt")
      append!(input, readlines("extra_package_names.txt"))
    end

    input = unique(input)

    println("Resolving packages: " * join(input, " "))

    pkgs = [PackageSpec(pkg) for pkg in input]

    ctx = Context()

    ${resolveCode}

    open(ENV["out"], "w") do io
      for spec in pkgs
        println(io, "- name: " * spec.name)
        println(io, "  uuid: " * string(spec.uuid))
        println(io, "  version: " * string(spec.version))
        if endswith(spec.name, "_jll") && haskey(deps_map, spec.uuid)
          println(io, "  depends_on: ")
          for (dep_name, dep_uuid) in pairs(deps_map[spec.uuid])
            println(io, "    \"$(dep_name)\": \"$(dep_uuid)\"")
          end
        end
      end
    end
  '';
in

runCommand "julia-package-closure.yml" { buildInputs = [julia (python3.withPackages (ps: with ps; [pyyaml]))]; } ''
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
  python ${./python}/find_package_implications.py "$out" '${lib.generators.toJSON {} packageImplications}' extra_package_names.txt

  if [ -f extra_package_names.txt ]; then
    echo "Re-resolving with additional package names"
    julia -e '${juliaExpression packageNames}';
  fi
''
