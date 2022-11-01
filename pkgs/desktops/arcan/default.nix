{ config, lib, pkgs }:

lib.makeScope pkgs.newScope (self: with self; {
  # Dependencies

  espeak = pkgs.espeak-ng;
  ffmpeg = pkgs.ffmpeg-full;
  harfbuzz = pkgs.harfbuzzFull;

  # Arcan

  arcan = callPackage ./arcan { };
  arcan-wrapped = callPackage ./wrapper.nix { };
  xarcan = callPackage ./xarcan { };

  # Appls

  cat9 = callPackage ./cat9 { };
  cat9-wrapped = callPackage ./wrapper.nix {
    name = "cat9-wrapped";
    appls = [ cat9 ];
  };

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
    appls = [ durden cat9 pipeworld ];
  };
})
