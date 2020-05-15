{deployAndroidPackage, requireFile, lib, packages, toolsVersion, autoPatchelfHook, makeWrapper, os, pkgs, pkgs_i686, postInstall ? ""}:

if toolsVersion == "26.0.1" then import ./tools/26.nix {
  inherit deployAndroidPackage lib autoPatchelfHook makeWrapper os pkgs pkgs_i686 postInstall;
  package = {
    name = "tools";
    path = "tools";
    revision = "26.0.1";
    archives = {
      linux = requireFile {
        url = "https://dl.google.com/android/repository/sdk-tools-linux-3859397.zip";
        sha256 = "185yq7qwxflw24ccm5d6zziwlc9pxmsm3f54pm9p7xm0ik724kj4";
      };
      macosx = requireFile {
        url = "https://dl.google.com/android/repository/sdk-tools-darwin-3859397.zip";
        sha256 = "1ycx9gzdaqaw6n19yvxjawywacavn1jc6sadlz5qikhgfr57b0aa";
      };
    };
  };
} else if toolsVersion == "26.1.1" then import ./tools/26.nix {
  inherit deployAndroidPackage lib autoPatchelfHook makeWrapper os pkgs pkgs_i686 postInstall;
  package = packages.tools.${toolsVersion};
} else import ./tools/25.nix {
  inherit deployAndroidPackage lib autoPatchelfHook makeWrapper os pkgs pkgs_i686 postInstall;
  package = packages.tools.${toolsVersion};
}
