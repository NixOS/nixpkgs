import Pkg.API: handle_package_input!
import Pkg.Types: PRESERVE_NONE, UUID, VersionSpec, project_deps_resolve!, registry_resolve!, stdlib_resolve!, ensure_resolved
import Pkg.Operations: _resolve, assert_can_add, update_package_add
import TOML

foreach(handle_package_input!, pkgs)

# The handle_package_input! call above clears pkg.path, so we have to apply package overrides after
println("Package overrides: ")
println(overrides)
for pkg in pkgs
    if pkg.name in keys(overrides)
        pkg.path = overrides[pkg.name]

        # Try to read the UUID from $(pkg.path)/Project.toml. If successful, put the package into ctx.env.project.deps.
        # This is necessary for the ensure_resolved call below to succeed, and will allow us to use an override even
        # if it does not appear in the registry.
        # See https://github.com/NixOS/nixpkgs/issues/279853
        project_toml = joinpath(pkg.path, "Project.toml")
        if isfile(project_toml)
            toml_data = TOML.parsefile(project_toml)
            if haskey(toml_data, "uuid")
                ctx.env.project.deps[pkg.name] = UUID(toml_data["uuid"])
            end
        end
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
    if VERSION >= VersionNumber("1.11")
        pkgs[i] = update_package_add(ctx, pkg, entry, nothing, nothing, is_dep)
    else
        pkgs[i] = update_package_add(ctx, pkg, entry, is_dep)
    end
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
            if VERSION >= VersionNumber("1.11")
                orig_pkgs[length(orig_pkgs)] = update_package_add(ctx, pkg, entry, nothing, nothing, false)
            else
                orig_pkgs[length(orig_pkgs)] = update_package_add(ctx, pkg, entry, false)
            end
        end

        global pkgs, deps_map = _resolve(ctx.io, ctx.env, ctx.registries, orig_pkgs, PRESERVE_NONE, ctx.julia_version)
    end
end
