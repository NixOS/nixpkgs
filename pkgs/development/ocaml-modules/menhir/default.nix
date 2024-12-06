{ buildDunePackage, substituteAll, ocaml
, menhirLib, menhirSdk
}:

buildDunePackage rec {
  pname = "menhir";

  minimalOCamlVersion = "4.03";

  inherit (menhirLib) version src;

  buildInputs = [ menhirLib menhirSdk ];

  patches = [
    (substituteAll {
      src = ./menhir-suggest-menhirLib.patch;
      libdir = "${menhirLib}/lib/ocaml/${ocaml.version}/site-lib/menhirLib";
    })
  ];

  meta = menhirSdk.meta // {
    description = "LR(1) parser generator for OCaml";
    mainProgram = "menhir";
  };
}
