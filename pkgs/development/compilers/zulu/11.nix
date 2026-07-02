{
  callPackage,
  enableJavaFX ? false,
  ...
}@args:
let
  zuluVersion = "11.88.17";
  jdkVersion = "11.0.31";
in
callPackage ./common.nix (
  {
    # Details from https://www.azul.com/downloads/?version=java-11-lts&package=jdk
    # Note that the latest build may differ by platform
    dists = {
      x86_64-linux = {
        inherit zuluVersion jdkVersion;
        hash =
          if enableJavaFX then
            "sha256-6XkzzHuNjX8OrTLBhFbfQ4ZOjZPLJw2pWvk7CiJzPXE="
          else
            "sha256-40dhkwxjCwZ9WkSTd+caFSgRVLGviC2scfJOK8PKk/k=";
      };

      aarch64-linux = {
        inherit zuluVersion jdkVersion;
        hash =
          if enableJavaFX then
            "sha256-yCispNSTxqPB8kg46tcDUWcjQQCn8bhtXM2w/oyrO54="
          else
            "sha256-j6ItLEU1W32zgfky+M2mD5WSmeKDYWfXnwzLOxRl8Ps=";
      };

      x86_64-darwin = {
        inherit zuluVersion jdkVersion;
        hash =
          if enableJavaFX then
            "sha256-slk4EU7Zl0cW2y2JBiCJ8yGs5h+cK2f81tRCgBOq5uA="
          else
            "sha256-+3OC3mQOo2ucJG0OACk7IJtTvTwPn5WPbcG5cT9DAAc=";
      };

      aarch64-darwin = {
        inherit zuluVersion jdkVersion;
        hash =
          if enableJavaFX then
            "sha256-X1ph5yeqI2GZZTIGn93szk8Ks1ekJ9KaE3LSeUuigP0="
          else
            "sha256-/nViFbw2DKsHA8nIUffkbUdiWR3/MwEUIKcQ1JUOebE=";
      };
    };
  }
  // removeAttrs args [ "callPackage" ]
)
