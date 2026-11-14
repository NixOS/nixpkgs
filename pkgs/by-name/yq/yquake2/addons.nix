{
  stdenv,
  lib,
  fetchFromGitHub,
  buildEnv,
  makeWrapper,
  copyDesktopItems,
  makeDesktopItem,
  yquake2,
}:

let
  games = import ./games.nix { inherit stdenv lib fetchFromGitHub; };

  wrapper = import ./wrapper.nix {
    inherit
      stdenv
      lib
      buildEnv
      makeWrapper
      yquake2
      copyDesktopItems
      makeDesktopItem
      ;
  };

in
{
  yquake2-ctf = wrapper {
    games = [ games.ctf ];
    name = "yquake2-ctf";
    inherit (games.ctf) description;
  };

  yquake2-ground-zero = wrapper {
    games = [ games.ground-zero ];
    name = "yquake2-ground-zero";
    inherit (games.ground-zero) description;
  };

  yquake2-the-reckoning = wrapper {
    games = [ games.the-reckoning ];
    name = "yquake2-the-reckoning";
    inherit (games.the-reckoning) description;
  };

  yquake2-all-games = wrapper {
    games = lib.attrValues games;
    name = "yquake2-all-games";
    description = "Yamagi Quake II with all add-on games";
  };
}
