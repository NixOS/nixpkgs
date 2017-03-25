{ stdenv, fetchurl, ocaml, jbuilder, findlib, base }:

stdenv.mkDerivation {
  name = "ocaml${ocaml.version}-stdio-0.9.0";

  src = fetchurl {
    url = http://ocaml.janestreet.com/ocaml-core/v0.9/files/stdio-v0.9.0.tar.gz;
    sha256 = "008b5y03223107gfv8qawdfyjvf5g97l472i5p5v8mp512wr7kj5";
  };

  buildInputs = [ ocaml jbuilder findlib ];
  propagatedBuildInputs = [ base ];

  inherit (jbuilder) installPhase;

  meta = {
    license = stdenv.lib.licenses.asl20;
    description = "Standard IO library for OCaml";
    homepage = https://github.com/janestreet/stdio;
    inherit (ocaml.meta) platforms;
  };
}
