
import Base: UUID
import Pkg.Artifacts: artifact_meta, artifact_names, find_artifacts_toml, load_artifacts_toml, select_downloadable_artifacts
import Pkg.BinaryPlatforms: AbstractPlatform, platform_key_abi, triplet
import Pkg.Operations: gen_build_code
import TOML

pkg_uuid = UUID(ARGS[1])
dir = ARGS[2]

artifacts_toml = find_artifacts_toml(dir)

if artifacts_toml == nothing
    print("")
    exit()
end

platform = platform_key_abi()

# Using collect_artifacts (from Pkg.jl) is more reliable than calling select_downloadable_artifacts directly.
# collect_artifacts includes support for .pkg/select_artifacts.jl, which may produce different results.
# If we use select_downloadable_artifacts here, then at depot build time it may try to download a different artifact
# and fail.

# However! The collect_artifacts from Pkg.jl doesn't allow us to pass lazy to select_downloadable_artifacts.
# So we have to paste our own version in here :(

function collect_artifacts(pkg_root::String; platform::AbstractPlatform)
    # Check to see if this package has an (Julia)Artifacts.toml
    artifacts_tomls = Tuple{String,Base.TOML.TOMLDict}[]
    for f in artifact_names
        artifacts_toml = joinpath(pkg_root, f)
        if isfile(artifacts_toml)
            selector_path = joinpath(pkg_root, ".pkg", "select_artifacts.jl")

            # If there is a dynamic artifact selector, run that in an appropriate sandbox to select artifacts
            if isfile(selector_path)
                # Despite the fact that we inherit the project, since the in-memory manifest
                # has not been updated yet, if we try to load any dependencies, it may fail.
                # Therefore, this project inheritance is really only for Preferences, not dependencies.
                select_cmd = Cmd(`$(gen_build_code(selector_path; inherit_project=true)) --startup-file=no $(triplet(platform))`)
                meta_toml = String(read(select_cmd))
                res = TOML.tryparse(meta_toml)
                if res isa TOML.ParserError
                    errstr = sprint(showerror, res; context=stderr)
                    pkgerror("failed to parse TOML output from running $(repr(selector_path)), got: \n$errstr")
                else
                    push!(artifacts_tomls, (artifacts_toml, TOML.parse(meta_toml)))
                end
            else
                # Otherwise, use the standard selector from `Artifacts`
                artifacts = select_downloadable_artifacts(artifacts_toml; platform, include_lazy=true)
                push!(artifacts_tomls, (artifacts_toml, artifacts))
            end
            break
        end
    end
    return artifacts_tomls
end

for (artifacts_toml, artifacts) in collect_artifacts(dir; platform)
    TOML.print(artifacts)
end
