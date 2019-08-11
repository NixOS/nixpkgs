{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg, uchar, uucp, uutf, cmdliner }:

let
  pname = "uuseg";
  webpage = "https://erratique.ch/software/${pname}";
in

stdenv.mkDerivation rec {

  name = "ocaml${ocaml.version}-${pname}-${version}";
  version = "11.0.0";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "17mn8p9pn340kmvfgnl1m64zbpy60r6svkwsdn2lcg3yi2jlbrwp";
  };

  buildInputs = [ ocaml findlib ocamlbuild cmdliner topkg uutf ];
  propagatedBuildInputs = [ uucp uchar ];

  inherit (topkg) buildPhase installPhase;

  meta = with stdenv.lib; {
    description = "An OCaml library for segmenting Unicode text";
    homepage = "${webpage}";
    platforms = ocaml.meta.platforms or [];
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
  };
}
