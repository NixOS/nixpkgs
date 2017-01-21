{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, topkg, uchar }:

let
  pname = "uucp";
  version = "2.0.0";
  webpage = "http://erratique.ch/software/${pname}";
in

assert stdenv.lib.versionAtLeast ocaml.version "4.01";

stdenv.mkDerivation {

  name = "ocaml${ocaml.version}-${pname}-${version}";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "07m7pfpcf03dqsbvqpq88y9hzic8fighlp4fgbav6n6xla35mk5k";
  };

  buildInputs = [ ocaml findlib ocamlbuild opam topkg ];

  propagatedBuildInputs = [ uchar ];

  createFindlibDestdir = true;

  unpackCmd = "tar xjf $src";

  inherit (topkg) buildPhase installPhase;

  meta = with stdenv.lib; {
    description = "An OCaml library providing efficient access to a selection of character properties of the Unicode character database";
    homepage = "${webpage}";
    platforms = ocaml.meta.platforms or [];
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
  };
}
