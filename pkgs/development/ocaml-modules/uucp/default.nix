{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, topkg, uchar, uutf, uunf }:

let
  pname = "uucp";
  version = "10.0.1";
  webpage = "http://erratique.ch/software/${pname}";
in

assert stdenv.lib.versionAtLeast ocaml.version "4.01";

stdenv.mkDerivation {

  name = "ocaml${ocaml.version}-${pname}-${version}";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "0qgbrx3lnrzii8a9f0hv4kp73y57q6fr79hskxxxs70q68j2xpfm";
  };

  buildInputs = [ ocaml findlib ocamlbuild opam topkg uutf uunf ];

  propagatedBuildInputs = [ uchar ];

  createFindlibDestdir = true;

  unpackCmd = "tar xjf $src";

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
