{ callPackage, lib, pkgs }:

rec {
  # Dependencies

  espeak = pkgs.espeak-ng;
  ffmpeg = pkgs.ffmpeg-full;
  harfbuzz = pkgs.harfbuzzFull;

  # Arcan

  arcan = callPackage ./arcan.nix { };
  arcan-wrapped = callPackage ./wrapper.nix { };
  xarcan = callPackage ./xarcan.nix { };

  # Appls

  durden = callPackage ./durden.nix { };
  durden-wrapped = callPackage ./wrapper.nix {
    name = "durden-wrapped";
    appls = [ durden ];
  };

  pipeworld = callPackage ./pipeworld.nix { };
  pipeworld-wrapped = callPackage ./wrapper.nix {
    name = "pipeworld-wrapped";
    appls = [ pipeworld ];
  };
}
