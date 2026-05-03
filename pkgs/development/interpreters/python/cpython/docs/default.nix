{
  stdenv,
  fetchurl,
  lib,
}:

let
  pythonDocs = {
    html = {
      recurseForDerivations = true;
      python310 = import ./3.10-html.nix {
        inherit stdenv fetchurl lib;
      };
    };
    pdf_a4 = {
      recurseForDerivations = true;
      python310 = import ./3.10-pdf-a4.nix {
        inherit stdenv fetchurl lib;
      };
    };
    pdf_letter = {
      recurseForDerivations = true;
      python310 = import ./3.10-pdf-letter.nix {
        inherit stdenv fetchurl lib;
      };
    };
    text = {
      recurseForDerivations = true;
      python310 = import ./3.10-text.nix {
        inherit stdenv fetchurl lib;
      };
    };
    texinfo = {
      recurseForDerivations = true;
      python310 = import ./3.10-texinfo.nix {
        inherit stdenv fetchurl lib;
      };
    };
  };
in
pythonDocs
