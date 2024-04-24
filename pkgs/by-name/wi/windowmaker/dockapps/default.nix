{ config, lib, pkgs }:

lib.makeScope pkgs.newScope (self: {

  dockapps-sources = {
    pname = "dockapps-sources";
    version = "2023-10-11"; # Shall correspond to src.rev

    src = pkgs.fetchFromRepoOrCz {
      repo = "dockapps";
      rev = "1bbb32008ecb58acaec9ea70e00b4ea1735408fc";
      hash = "sha256-BLUDe/cIIuh9mCtafbcBSDatUXSRD83FeyYhcbem5FU=";
    };
  };

  AlsaMixer-app = self.callPackage ./AlsaMixer-app.nix { };

  cputnik = self.callPackage ./cputnik.nix { };

  libdockapp = self.callPackage ./libdockapp.nix { };

  wmCalClock = self.callPackage ./wmCalClock.nix { };

  wmcube = self.callPackage ./wmcube.nix { };

  wmsm-app = self.callPackage ./wmsm-app.nix { };

  wmsystemtray = self.callPackage ./wmsystemtray.nix { };
})
