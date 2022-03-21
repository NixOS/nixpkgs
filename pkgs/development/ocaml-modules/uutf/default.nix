{ lib, stdenv, fetchurl, ocaml, findlib, ocamlbuild, cmdliner , topkg, uchar }:
let
  pname = "uutf";
  webpage = "https://erratique.ch/software/${pname}";
in

stdenv.mkDerivation rec {
  name = "ocaml${ocaml.version}-${pname}-${version}";
  version = "1.0.2";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "1nx1rly3qj23jzn9yk3x6fwqimcxjd84kv5859vvhdg56psq26p6";
  };

  nativeBuildInputs = [ ocaml ocamlbuild findlib topkg ];
  buildInputs = [ topkg cmdliner ];
  propagatedBuildInputs = [ uchar ];

  strictDeps = true;

  inherit (topkg) buildPhase installPhase;

  meta = with lib; {
    description = "Non-blocking streaming Unicode codec for OCaml";
    homepage = webpage;
    platforms = ocaml.meta.platforms or [];
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
  };
}
