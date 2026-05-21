{
  buildDunePackage,
  replaceVars,
  ocaml,
  menhirGLR,
  menhirLib,
  menhirSdk,
}:

buildDunePackage {
  pname = "menhir";

  inherit (menhirLib) version src;

  buildInputs = [
    menhirGLR
    menhirLib
    menhirSdk
  ];

  patches = [
    (replaceVars ./menhir-suggest-menhirLib.patch {
      libdir = "${menhirLib}/lib/ocaml/${ocaml.version}/site-lib/menhirLib";
    })
  ];

  meta = menhirSdk.meta // {
    description = "LR(1) parser generator for OCaml";
    mainProgram = "menhir";
  };
}
