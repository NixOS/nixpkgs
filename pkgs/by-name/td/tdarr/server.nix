{ callPackage, ccextractor }:

callPackage ./common.nix { } {
  pname = "tdarr-server";
  component = "server";

  hashes = {
    linux_x64 = "sha256-sf7/5mGYE1qUNDPaH8DK7jZta3zpDlmFXlxs716bxwc=";
    linux_arm64 = "sha256-LViLBsjZoShdT9gGlgE9Y7QTyhLpFOsU1+cwD25glsk=";
    darwin_x64 = "sha256-YIQi6g7Z0GqduL4NGhfZXdAeWEPV+Tpv2RkW02EJ3W0=";
    darwin_arm64 = "sha256-ux9V9BA6nwRzYzrH9s+ciAfj8vc9yHYsAfsl66cSRZE=";
  };

  includeInPath = [ ccextractor ];
  installIcons = true;
}
