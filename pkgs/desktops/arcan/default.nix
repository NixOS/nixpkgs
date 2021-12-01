{ callPackage, lib, pkgs }:

rec {
  # Dependencies

  espeak = pkgs.espeak-ng;
  ffmpeg = pkgs.ffmpeg-full;
  harfbuzz = pkgs.harfbuzzFull;

  # Arcan

  arcan = callPackage ./arcan { };
  arcan-wrapped = callPackage ./wrapper.nix { };
  xarcan = callPackage ./xarcan { };

  # Appls

  durden = callPackage ./durden { };
  durden-wrapped = callPackage ./wrapper.nix {
    name = "durden-wrapped";
    appls = [ durden ];
  };

  pipeworld = callPackage ./pipeworld { };
  pipeworld-wrapped = callPackage ./wrapper.nix {
    name = "pipeworld-wrapped";
    appls = [ pipeworld ];
  };

  # Warning: prio is deprecated; however it works and is useful for testing
  prio = callPackage ./prio { };
  prio-wrapped = callPackage ./wrapper.nix {
    name = "prio-wrapped";
    appls = [ prio ];
  };

  # One Expression to SymlinkJoin Them All

  all-wrapped = callPackage ./wrapper.nix {
    name = "all-wrapped";
    appls = [ durden pipeworld ];
  };
}
