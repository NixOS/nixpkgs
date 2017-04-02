{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, topkg, uchar, uutf, cmdliner }:
let
  pname = "uunf";
  webpage = "http://erratique.ch/software/${pname}";
in

assert stdenv.lib.versionAtLeast ocaml.version "4.01";

stdenv.mkDerivation rec {
  name = "ocaml-${pname}-${version}";
  version = "2.0.0";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "1i132168949vdc8magycgf9mdysf50vvr7zngnjl4vi3zdayq20c";
  };

  buildInputs = [ ocaml findlib ocamlbuild opam topkg uutf cmdliner ];

  propagatedBuildInputs = [ uchar ];

  createFindlibDestdir = true;

  unpackCmd = "tar xjf $src";

  inherit (topkg) buildPhase installPhase;

  meta = with stdenv.lib; {
    description = "An OCaml module for normalizing Unicode text";
    homepage = "${webpage}";
    platforms = ocaml.meta.platforms or [];
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
  };
}
