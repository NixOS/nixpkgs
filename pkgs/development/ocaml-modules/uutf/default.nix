{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, opam, cmdliner , topkg, uchar }:
let
  pname = "uutf";
  webpage = "http://erratique.ch/software/${pname}";
in

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-${pname}-${version}";
  version = "1.0.1";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "1gp96dcggq7s84934vimxh89caaxa77lqiff1yywbwkilkkjcfqj";
  };

  buildInputs = [ ocaml findlib ocamlbuild topkg opam cmdliner ];
  propagatedBuildInputs = [ uchar ];

  createFindlibDestdir = true;

  unpackCmd = "tar xjf $src";

  inherit (topkg) buildPhase installPhase;

  meta = with stdenv.lib; {
    description = "Non-blocking streaming Unicode codec for OCaml";
    homepage = "${webpage}";
    platforms = ocaml.meta.platforms or [];
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
  };
}
