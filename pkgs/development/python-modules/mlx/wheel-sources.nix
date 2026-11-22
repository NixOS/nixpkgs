{
  version = "0.32.4";
  # Hash of the upstream source used for examples and benchmarks matching the wheel version.
  testSourceHash = "sha256-Bs8c1+GvJuUsrB/KrW6Sjfe8noS8P+M7dwBQY0XJtaU=";

  mlx = {
    "3.13-aarch64-darwin" = {
      platform = "macosx_14_0_arm64";
      dist = "cp313";
      hash = "sha256-xzdfLWrNjHL0E9AYJmrgY4fLnKqzH0dfP/HFYAp8tMU=";
    };
    "3.14-aarch64-darwin" = {
      platform = "macosx_14_0_arm64";
      dist = "cp314";
      hash = "sha256-8ebvRB4eLOVBWQIqj6VZf46k96zyeHUgScT3dLvQUB0=";
    };
  };

  mlx-metal = {
    "14" = {
      platform = "macosx_14_0_arm64";
      hash = "sha256-gBmy22IlmSZ9ZswWiy8Nv1r5KXkKbDs5E+AOq8QqeUc=";
    };
    "15" = {
      platform = "macosx_15_0_arm64";
      hash = "sha256-nwo8wm2JckQ02WhJMvxvPk6DZp0qiV2FjtLIpV64Tos=";
    };
    # Includes NAX kernels for supported GPUs running macOS 26.2 or newer.
    "26" = {
      platform = "macosx_26_0_arm64";
      hash = "sha256-UU35LUGiholdJWS0sY9NpFCWvXpKDEfhBC80WtWn+TY=";
    };
  };
}
