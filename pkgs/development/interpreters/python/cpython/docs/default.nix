{
  stdenv,
  fetchurl,
  lib,
}:

let
  pythonDocs = {
    html = {
      recurseForDerivations = true;
      python315 = import ./3.15-html.nix {
        inherit stdenv fetchurl lib;
      };
    };
    text = {
      recurseForDerivations = true;
      python315 = import ./3.15-text.nix {
        inherit stdenv fetchurl lib;
      };
    };
    texinfo = {
      recurseForDerivations = true;
      python315 = import ./3.15-texinfo.nix {
        inherit stdenv fetchurl lib;
      };
    };
  };
in
pythonDocs
