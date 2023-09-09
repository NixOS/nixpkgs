{ config, lib, pkgs }:

lib.makeScope pkgs.newScope (self: with self; {

  dockapps-sources = pkgs.fetchgit {
    url = "https://repo.or.cz/dockapps.git";
    rev = "b2b9d872ee61c9b329e4597c301e4417cbd9c3ea";
    sha256 = "sha256-BuSnwPIj3gUWMjj++SK+117xm/77u4gXLQzRFttei0w=";
  };

  libdockapp = callPackage ./libdockapp.nix { };

  AlsaMixer-app = callPackage ./AlsaMixer-app.nix { };

  wmCalClock = callPackage ./wmCalClock.nix { };

  wmsm-app = callPackage ./wmsm-app.nix { };

  wmsystemtray = callPackage ./wmsystemtray.nix { };
})
