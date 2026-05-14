
import Base: UUID
import Pkg.Artifacts: artifact_meta, find_artifacts_toml, load_artifacts_toml
import Pkg.BinaryPlatforms: platform_key_abi
import TOML

pkg_uuid = UUID(ARGS[1])
dir = ARGS[2]

artifacts_toml = find_artifacts_toml(dir)

if artifacts_toml == nothing
    print("")
    exit()
end

platform = platform_key_abi()

# Older Julia doesn't provide select_downloadable_artifacts or .pkg/select_artifacts.jl,
# so gather the artifacts the old-fashioned way
artifact_dict = load_artifacts_toml(artifacts_toml; pkg_uuid=pkg_uuid)

results = Dict()
for name in keys(artifact_dict)
    # Get the metadata about this name for the requested platform
    meta = artifact_meta(name, artifact_dict, artifacts_toml; platform=platform)

    # If there are no instances of this name for the desired platform, skip it
    meta === nothing && continue

    results[name] = meta
end
TOML.print(results)
