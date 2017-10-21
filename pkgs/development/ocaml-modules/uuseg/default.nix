{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, topkg, uchar, uucp, uutf, cmdliner }:

let
  pname = "uuseg";
  webpage = "http://erratique.ch/software/${pname}";
in

stdenv.mkDerivation rec {

  name = "ocaml${ocaml.version}-${pname}-${version}";
  version = "10.0.0";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "01q8ljjgi7d73x7ms489b5my83xds4jax1vbjhwwjdai01friscc";
  };

  buildInputs = [ ocaml findlib ocamlbuild opam cmdliner topkg uutf ];
  propagatedBuildInputs = [ uucp uchar ];

  createFindlibDestdir = true;

  unpackCmd = "tar xjf $src";

  inherit (topkg) buildPhase installPhase;

  meta = with stdenv.lib; {
    description = "An OCaml library for segmenting Unicode text";
    homepage = "${webpage}";
    platforms = ocaml.meta.platforms or [];
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
  };
}
