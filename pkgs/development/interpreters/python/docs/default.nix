{ stdenv, fetchurl }:

let
pythonDocs = {
  html = {
    python33 = import ./3.3-html.nix {
      inherit stdenv fetchurl;
    };
    python32 = import ./3.2-html.nix {
      inherit stdenv fetchurl;
    };
    python31 = import ./3.1-html.nix {
      inherit stdenv fetchurl;
    };
    python30 = import ./3.0-html.nix {
      inherit stdenv fetchurl;
    };
    python27 = import ./2.7-html.nix {
      inherit stdenv fetchurl;
    };
    python26 = import ./2.6-html.nix {
      inherit stdenv fetchurl;
    };
  };
  pdf_a4 = {
    python33 = import ./3.3-pdf-a4.nix {
      inherit stdenv fetchurl;
    };
    python32 = import ./3.2-pdf-a4.nix {
      inherit stdenv fetchurl;
    };
    python31 = import ./3.1-pdf-a4.nix {
      inherit stdenv fetchurl;
    };
    python30 = import ./3.0-pdf-a4.nix {
      inherit stdenv fetchurl;
    };
    python27 = import ./2.7-pdf-a4.nix {
      inherit stdenv fetchurl;
    };
    python26 = import ./2.6-pdf-a4.nix {
      inherit stdenv fetchurl;
    };
  };
  pdf_letter = {
    python33 = import ./3.3-pdf-letter.nix {
      inherit stdenv fetchurl;
    };
    python32 = import ./3.2-pdf-letter.nix {
      inherit stdenv fetchurl;
    };
    python31 = import ./3.1-pdf-letter.nix {
      inherit stdenv fetchurl;
    };
    python30 = import ./3.0-pdf-letter.nix {
      inherit stdenv fetchurl;
    };
    python27 = import ./2.7-pdf-letter.nix {
      inherit stdenv fetchurl;
    };
    python26 = import ./2.6-pdf-letter.nix {
      inherit stdenv fetchurl;
    };
  };
  text = {
    python33 = import ./3.3-text.nix {
      inherit stdenv fetchurl;
    };
    python32 = import ./3.2-text.nix {
      inherit stdenv fetchurl;
    };
    python31 = import ./3.1-text.nix {
      inherit stdenv fetchurl;
    };
    python30 = import ./3.0-text.nix {
      inherit stdenv fetchurl;
    };
    python27 = import ./2.7-text.nix {
      inherit stdenv fetchurl;
    };
    python26 = import ./2.6-text.nix {
      inherit stdenv fetchurl;
    };
  };
}; in pythonDocs
