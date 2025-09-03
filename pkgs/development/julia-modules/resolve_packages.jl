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
orig_pkgs = deepcopy(pkgs)

pkgs, deps_map = _resolve(ctx.io, ctx.env, ctx.registries, pkgs, PRESERVE_NONE, ctx.julia_version)
