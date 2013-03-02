{ stdenv, fetchurl }:

let
pythonDocs = {
  python33_html = import ./3.3-html.nix {
    inherit stdenv fetchurl;
  };
  python33_pdf_a4 = import ./3.3-pdf-a4.nix {
    inherit stdenv fetchurl;
  };
  python33_pdf_letter = import ./3.3-pdf-letter.nix {
    inherit stdenv fetchurl;
  };
  python33_text = import ./3.3-text.nix {
    inherit stdenv fetchurl;
  };
  python32_html = import ./3.2-html.nix {
    inherit stdenv fetchurl;
  };
  python32_pdf_a4 = import ./3.2-pdf-a4.nix {
    inherit stdenv fetchurl;
  };
  python32_pdf_letter = import ./3.2-pdf-letter.nix {
    inherit stdenv fetchurl;
  };
  python32_text = import ./3.2-text.nix {
    inherit stdenv fetchurl;
  };
  python31_html = import ./3.1-html.nix {
    inherit stdenv fetchurl;
  };
  python31_pdf_a4 = import ./3.1-pdf-a4.nix {
    inherit stdenv fetchurl;
  };
  python31_pdf_letter = import ./3.1-pdf-letter.nix {
    inherit stdenv fetchurl;
  };
  python31_text = import ./3.1-text.nix {
    inherit stdenv fetchurl;
  };
  python30_html = import ./3.0-html.nix {
    inherit stdenv fetchurl;
  };
  python30_pdf_a4 = import ./3.0-pdf-a4.nix {
    inherit stdenv fetchurl;
  };
  python30_pdf_letter = import ./3.0-pdf-letter.nix {
    inherit stdenv fetchurl;
  };
  python30_text = import ./3.0-text.nix {
    inherit stdenv fetchurl;
  };
  python27_html = import ./2.7-html.nix {
    inherit stdenv fetchurl;
  };
  python27_pdf_a4 = import ./2.7-pdf-a4.nix {
    inherit stdenv fetchurl;
  };
  python27_pdf_letter = import ./2.7-pdf-letter.nix {
    inherit stdenv fetchurl;
  };
  python27_text = import ./2.7-text.nix {
    inherit stdenv fetchurl;
  };
  python26_html = import ./2.6-html.nix {
    inherit stdenv fetchurl;
  };
  python26_pdf_a4 = import ./2.6-pdf-a4.nix {
    inherit stdenv fetchurl;
  };
  python26_pdf_letter = import ./2.6-pdf-letter.nix {
    inherit stdenv fetchurl;
  };
  python26_text = import ./2.6-text.nix {
    inherit stdenv fetchurl;
  };
}; in pythonDocs
