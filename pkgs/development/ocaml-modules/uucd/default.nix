{ lib, stdenv, fetchurl, ocaml, findlib, ocamlbuild, xmlm, topkg }:

let
  pname = "uucd";
  webpage = "https://erratique.ch/software/${pname}";
in
stdenv.mkDerivation rec {
  name = "ocaml-${pname}-${version}";
  version = "13.0.0";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "1fg77hg4ibidkv1x8hhzl8z3rzmyymn8m4i35jrdibb8adigi8v2";
  };

  buildInputs = [ ocaml findlib ocamlbuild topkg ];

  inherit (topkg) buildPhase installPhase;

  propagatedBuildInputs = [ xmlm ];

  meta = with lib; {
    description = "An OCaml module to decode the data of the Unicode character database from its XML representation";
    homepage = webpage;
    platforms = ocaml.meta.platforms or [];
    maintainers = [ maintainers.vbgl ];
    license = licenses.bsd3;
  };
}
