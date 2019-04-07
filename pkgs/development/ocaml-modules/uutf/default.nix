{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, cmdliner , topkg, uchar }:
let
  pname = "uutf";
  webpage = "http://erratique.ch/software/${pname}";
in

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-${pname}-${version}";
  version = "1.0.2";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "1nx1rly3qj23jzn9yk3x6fwqimcxjd84kv5859vvhdg56psq26p6";
  };

  buildInputs = [ ocaml findlib ocamlbuild topkg cmdliner ];
  propagatedBuildInputs = [ uchar ];

  inherit (topkg) buildPhase installPhase;

  meta = with stdenv.lib; {
    description = "Non-blocking streaming Unicode codec for OCaml";
    homepage = "${webpage}";
    platforms = ocaml.meta.platforms or [];
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
  };
}
