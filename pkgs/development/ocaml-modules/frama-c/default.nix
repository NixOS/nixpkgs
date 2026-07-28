{
  stdenv,
  pkgs,
  ocaml,
  findlib,
  frama-c,
  camlzip,
  dune-site,
  ocamlgraph,
  menhirLib,
  ppx_deriving,
  ppx_inline_test,
  yaml,
  yojson,
  zarith,
  zmq,
}:

stdenv.mkDerivation {
  pname = "ocaml${ocaml.version}-frama-c";
  inherit (frama-c) version meta;

  dontUnpack = true;

  buildInputs = [ findlib ];

  propagatedBuildInputs = [
    camlzip
    dune-site
    menhirLib
    ocamlgraph
    ppx_deriving
    ppx_inline_test
    yaml
    yojson
    zarith
    zmq
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $OCAMLFIND_DESTDIR
    for p in ${frama-c}/lib/*
    do
      ln -s $p $OCAMLFIND_DESTDIR/
    done
    runHook postInstall
  '';
}
