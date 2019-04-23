{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg, uchar, uutf, uunf }:

let
  pname = "uucp";
  version = "11.0.0";
  webpage = "https://erratique.ch/software/${pname}";
in

assert stdenv.lib.versionAtLeast ocaml.version "4.01";

stdenv.mkDerivation {

  name = "ocaml${ocaml.version}-${pname}-${version}";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "0pidg2pmqsifmk4xx9cc5p5jprhg26xb68g1xddjm7sjzbdzhlm4";
  };

  buildInputs = [ ocaml findlib ocamlbuild topkg uutf uunf ];

  propagatedBuildInputs = [ uchar ];

  buildPhase = "${topkg.buildPhase} --with-cmdliner false";

  inherit (topkg) installPhase;

  meta = with stdenv.lib; {
    description = "An OCaml library providing efficient access to a selection of character properties of the Unicode character database";
    homepage = "${webpage}";
    platforms = ocaml.meta.platforms or [];
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
  };
}
