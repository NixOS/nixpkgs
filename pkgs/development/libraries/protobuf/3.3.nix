{ callPackage, lib, ... }:

lib.overrideDerivation (callPackage ./generic-v3.nix {
  version = "3.3.0";
  sha256 = "1258yz9flyyaswh3izv227kwnhwcxn4nwavdz9iznqmh24qmi59w";
}) (attrs: { NIX_CFLAGS_COMPILE = "-Wno-error"; })
