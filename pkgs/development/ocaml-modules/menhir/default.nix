{ lib, fetchFromGitLab, buildDunePackage
, menhirLib, menhirSdk
}:

buildDunePackage rec {
  pname = "menhir";

  minimalOCamlVersion = "4.03";

  inherit (menhirLib) version src useDune2;

  buildInputs = [ menhirLib menhirSdk ];

  meta = menhirSdk.meta // {
    description = "A LR(1) parser generator for OCaml";
  };
}
