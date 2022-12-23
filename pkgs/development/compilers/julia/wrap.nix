{ callPackage }:

julia: callPackage ./with-packages.nix { inherit julia; }
