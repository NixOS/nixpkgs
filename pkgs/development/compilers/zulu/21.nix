{
  callPackage,
  enableJavaFX ? false,
  ...
}@args:

callPackage ./common.nix (
  {
    # Details from https://www.azul.com/downloads/?version=java-21-lts&package=jdk
    # Note that the latest build may differ by platform
    dists = {
      x86_64-linux = {
        zuluVersion = "21.44.17";
        jdkVersion = "21.0.8";
        hash =
          if enableJavaFX then
            "sha256-T+bGfe0IoYwX1Odh66CdRL1fzbvA63NqM9e2hLCbx2Y="
          else
            "sha256-Y/Vru0aVjPVzUvugjydV4JU3mRleVUWswMipKSC+/x4=";
      };

      aarch64-linux = {
        zuluVersion = "21.44.17";
        jdkVersion = "21.0.8";
        hash =
          if enableJavaFX then
            "sha256-6qFwo2rBV+mbEFDZNoqEs3z+2saj31fsOHG9jToST2Q="
          else
            "sha256-/38u3R1cFTy2y0k6OqNSNFPimgXsUTslwkqhR37AxyI=";
      };

      x86_64-darwin = {
        zuluVersion = "21.44.17";
        jdkVersion = "21.0.8";
        hash =
          if enableJavaFX then
            "sha256-PGnYq+9MskgczsEjx4aH5yDYjZLw8Tk8IZSMOXw03aw="
          else
            "sha256-KvCAUAtcwoamNTGHx8WbWq/LPtwpwch9H9cbotalI/E=";
      };

      aarch64-darwin = {
        zuluVersion = "21.44.17";
        jdkVersion = "21.0.8";
        hash =
          if enableJavaFX then
            "sha256-Bj1cYFfm3dq+HB9tdnFwT7onVQ9Slf0zRFBK4z9LUoY="
          else
            "sha256-0izgX+o+PyjIxZ8sNIvHjulnvxKJpPsoeWzAF3/2yNs=";
      };
    };
  }
  // builtins.removeAttrs args [ "callPackage" ]
)
