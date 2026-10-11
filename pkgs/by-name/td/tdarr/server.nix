{ callPackage, ccextractor }:

callPackage ./common.nix { } {
  pname = "tdarr-server";
  component = "server";

  hashes = {
    linux_x64 = "sha256-YpYNHf/BdEWsXGDqcfYt7uexiao8KpQmUkzpIBve+kQ=";
    linux_arm64 = "sha256-dqBWAGwuoMiVw3He5+QUVDG9p+/UmDrsx8dJENT/9vA=";
    darwin_x64 = "sha256-MfejahnPyUxfqVyNvIZ927lN7iM90/JnIdQ+n9j87Tg=";
    darwin_arm64 = "sha256-5U4k2mArCLv4+Cma6ZBxe2kCBfxnSZlgjW3BDf8MWRk=";
  };

  includeInPath = [ ccextractor ];
  installIcons = true;
}
