{
  stdenv,
  fetchurl,
  lib,
}:

let
  pythonDocs = {
    html = {
      recurseForDerivations = true;
      python314 = import ./3.14-html.nix {
        inherit stdenv fetchurl lib;
      };
    };
    text = {
      recurseForDerivations = true;
      python314 = import ./3.14-text.nix {
        inherit stdenv fetchurl lib;
      };
    };
    texinfo = {
      recurseForDerivations = true;
      python314 = import ./3.14-texinfo.nix {
        inherit stdenv fetchurl lib;
      };
    };
  };
in
pythonDocs
