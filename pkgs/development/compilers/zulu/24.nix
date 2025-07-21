{
  callPackage,
  enableJavaFX ? false,
  ...
}@args:

let
  # For 24 JDK FX is newer than regular JDK
  zuluVersion = if enableJavaFX then "24.30.13" else "24.30.11";
in
callPackage ./common.nix (
  {
    # Details from https://www.azul.com/downloads/?version=java-24&package=jdk
    # Note that the latest build may differ by platform
    dists = {
      x86_64-linux = {
        inherit zuluVersion;
        jdkVersion = "24.0.1";
        hash =
          if enableJavaFX then
            "sha256-jbpWNE+X5GJABQERq126ediyzGRQE9NZy9oMW/sPUa0="
          else
            "sha256-EvaVfDoqdNNtaSz+467rlJ8VtdgNrQi/DT7ZMNZthlk=";
      };

      aarch64-linux = {
        inherit zuluVersion;
        jdkVersion = "24.0.1";
        hash =
          if enableJavaFX then
            "sha256-N9VOweloyX/2bFPH3L+Iw7nTkbiE7LvDNnTNM1b8Ghc="
          else
            "sha256-4R5K5XTgpR9kq9WWE3SgvqVTq8CFvyb943zAiSsq3k0=";
      };

      x86_64-darwin = {
        inherit zuluVersion;
        jdkVersion = "24.0.1";
        hash =
          if enableJavaFX then
            "sha256-c6Gwj8ol2YLfo4sMeCMGfYQvtDz7029L0Yj1dqVQvsw="
          else
            "sha256-VhGOiZaspXeVVLEp0MJZXxj/+ovGgmy+gRb2BZ9OuhY=";
      };

      aarch64-darwin = {
        inherit zuluVersion;
        jdkVersion = "24.0.1";
        hash =
          if enableJavaFX then
            "sha256-Sac+DxNyGqsiStpc/wZYd2K7rvPEjo901kOYERYi+Sw="
          else
            "sha256-pJsq2gKcTy44zbFbSAj6Kd5VZi095jKGkZqd8ceIz7E=";
      };
    };
  }
  // builtins.removeAttrs args [ "callPackage" ]
)
