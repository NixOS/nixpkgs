{ stdenv, ocaml, findlib, ounit2 }:

stdenv.mkDerivation {
  pname = "ocaml${ocaml.version}-ounit";
  inherit (ounit2) version src meta;

  buildInputs = [ findlib ];
  propagatedBuildInputs = [ ounit2 ];

  phases = [ "unpackPhase" "installPhase" "fixupPhase" ];

  preInstall = ''
    mkdir -p "$OCAMLFIND_DESTDIR"
  '';

  installTargets = "install-ounit version='${ounit2.version}'";

}
