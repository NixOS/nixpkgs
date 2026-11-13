{ callPackage, ccextractor }:

callPackage ./common.nix { } {
  pname = "tdarr-server";
  component = "server";

  hashes = {
    linux_x64 = "sha256-ZyWs710xd34+fj2jCRKIJGe6by6Id3vlIy/golumi0o=";
    linux_arm64 = "sha256-cmhRNZJTflRS3eFGFXTnbX3d8NfOUzXxzG5XWNl5iPM=";
    darwin_arm64 = "sha256-A+W/hTELVm8aVUvhN49NO5KbI88MmJsH2ktre4GTM3s=";
  };

  includeInPath = [ ccextractor ];
  installIcons = true;
}
