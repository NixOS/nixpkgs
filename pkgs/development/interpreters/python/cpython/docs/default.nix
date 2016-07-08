{ stdenv, fetchurl, lib }:

let
pythonDocs = {
  html = {
    recurseForDerivations = true;
    python33 = import ./3.3-html.nix {
      inherit stdenv fetchurl lib;
    };
    python27 = import ./2.7-html.nix {
      inherit stdenv fetchurl lib;
    };
    python26 = import ./2.6-html.nix {
      inherit stdenv fetchurl lib;
    };
  };
  pdf_a4 = {
    recurseForDerivations = true;
    python33 = import ./3.3-pdf-a4.nix {
      inherit stdenv fetchurl lib;
    };
    python27 = import ./2.7-pdf-a4.nix {
      inherit stdenv fetchurl lib;
    };
    python26 = import ./2.6-pdf-a4.nix {
      inherit stdenv fetchurl lib;
    };
  };
  pdf_letter = {
    recurseForDerivations = true;
    python33 = import ./3.3-pdf-letter.nix {
      inherit stdenv fetchurl lib;
    };
    python27 = import ./2.7-pdf-letter.nix {
      inherit stdenv fetchurl lib;
    };
    python26 = import ./2.6-pdf-letter.nix {
      inherit stdenv fetchurl lib;
    };
  };
  text = {
    recurseForDerivations = true;
    python33 = import ./3.3-text.nix {
      inherit stdenv fetchurl lib;
    };
    python27 = import ./2.7-text.nix {
      inherit stdenv fetchurl lib;
    };
    python26 = import ./2.6-text.nix {
      inherit stdenv fetchurl lib;
    };
  };
}; in pythonDocs
