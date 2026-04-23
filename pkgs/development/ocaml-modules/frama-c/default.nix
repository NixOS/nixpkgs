{
  stdenv,
  pkgs,
  ocaml,
  findlib,
  framac,
  camlzip,
  dune-site,
  ocamlgraph,
  menhirLib,
  ppx_deriving,
  yaml,
  yojson,
  zarith,
}:

stdenv.mkDerivation {
  pname = "ocaml${ocaml.version}-frama-c";
  inherit (framac) version meta;

  dontUnpack = true;

  buildInputs = [ findlib ];

  propagatedBuildInputs = [
    camlzip
    dune-site
    menhirLib
    ocamlgraph
    ppx_deriving
    yaml
    yojson
    zarith
  ];

  installPhase = ''
    runHook preInstall
    mkdir -p $OCAMLFIND_DESTDIR
    for p in ${framac}/lib/*
    do
      ln -s $p $OCAMLFIND_DESTDIR/
    done
    runHook postInstall
  '';
}
