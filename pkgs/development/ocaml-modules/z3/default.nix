{ stdenv, ocaml, findlib, zarith, z3 }:

let z3-with-ocaml = z3.override {
  ocamlBindings = true;
  inherit ocaml findlib zarith;
}; in

stdenv.mkDerivation {

  pname = "ocaml${ocaml.version}-z3";
  inherit (z3-with-ocaml) version;

  phases = [ "installPhase" "fixupPhase" ];

  installPhase = ''
    runHook preInstall
    mkdir -p $OCAMLFIND_DESTDIR
    cp -r ${z3-with-ocaml.ocaml}/lib/ocaml/${ocaml.version}/site-lib/stublibs $OCAMLFIND_DESTDIR
    cp -r ${z3-with-ocaml.ocaml}/lib/ocaml/${ocaml.version}/site-lib/Z3 $OCAMLFIND_DESTDIR/z3
    runHook postInstall
  '';

  buildInputs = [ findlib ];
  propagatedBuildInputs = [ zarith ];

  meta = z3.meta // {
    description = "Z3 Theorem Prover (OCaml API)";
  };
}
