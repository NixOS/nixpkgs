{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg, uchar, uutf, cmdliner }:
let
  pname = "uunf";
  webpage = "https://erratique.ch/software/${pname}";
in

assert stdenv.lib.versionAtLeast ocaml.version "4.01";

stdenv.mkDerivation rec {
  name = "ocaml-${pname}-${version}";
  version = "11.0.0";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "1j0v3dg19sq13fmbx4kzy3n1hjiv7hkm1ysxyrdva430jvqw23df";
  };

  buildInputs = [ ocaml findlib ocamlbuild topkg uutf cmdliner ];

  propagatedBuildInputs = [ uchar ];

  inherit (topkg) buildPhase installPhase;

  meta = with stdenv.lib; {
    description = "An OCaml module for normalizing Unicode text";
    homepage = "${webpage}";
    platforms = ocaml.meta.platforms or [];
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
    broken = stdenv.isAarch64;
  };
}
