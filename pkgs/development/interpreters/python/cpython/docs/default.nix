{ callPackage }:

let
pythonDocs = {
  html = {
    recurseForDerivations = true;
    python27 = callPackage ./2.7-html.nix { };
    python312 = callPackage ./3.12-html.nix { };
  };
  pdf_a4 = {
    recurseForDerivations = true;
    python27 = callPackage ./2.7-pdf-a4.nix { };
    python312 = callPackage ./3.12-pdf-a4.nix { };
  };
  pdf_letter = {
    recurseForDerivations = true;
    python27 = callPackage ./2.7-pdf-letter.nix { };
    python312 = callPackage ./3.12-pdf-letter.nix { };
  };
  text = {
    recurseForDerivations = true;
    python27 = callPackage ./2.7-text.nix { };
    python312 = callPackage ./3.12-text.nix { };
  };
  texinfo = {
    recurseForDerivations = true;
    python312 = callPackage ./3.12-texinfo.nix { };
  };
}; in pythonDocs
