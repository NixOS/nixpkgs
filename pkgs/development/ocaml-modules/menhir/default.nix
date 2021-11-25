{ lib, fetchFromGitLab, buildDunePackage
, menhirLib, menhirSdk
}:

buildDunePackage rec {
  pname = "menhir";

  inherit (menhirLib) version src useDune2;

  buildInputs = [ menhirLib menhirSdk ];

  meta = menhirSdk.meta // {
    description = "A LR(1) parser generator for OCaml";
  };
}
