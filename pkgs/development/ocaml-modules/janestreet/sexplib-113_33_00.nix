{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, topkg }:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-sexplib-113.33.00+4.03";
  src = fetchurl {
    url = http://ocaml.janestreet.com/ocaml-core/113.33/files/sexplib-113.33.00+4.03.tar.gz;
    sha256 = "1dirdrags3z8m80z1vczfnpdfzgcvm2wyy7g61fxdr8h3jgixpl3";
  };

  buildInputs = [ ocaml findlib ocamlbuild opam ];

  inherit (topkg) installPhase;

  meta = {
    license = stdenv.lib.licenses.asl20;
    inherit (ocaml.meta) platforms;
  };
}
