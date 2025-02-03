{ lib, stdenv, fetchurl, ocaml, findlib, ocamlbuild, xmlm, topkg }:

let
  pname = "uucd";
  webpage = "https://erratique.ch/software/${pname}";
in
stdenv.mkDerivation rec {
  name = "ocaml-${pname}-${version}";
  version = "15.1.0";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    hash = "sha256-HIANZ5SDJcytlpw/W9Ae2eFTutrutJj2PgJCfByobfI=";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild topkg ];
  buildInputs = [ topkg ];

  strictDeps = true;

  inherit (topkg) buildPhase installPhase;

  propagatedBuildInputs = [ xmlm ];

  meta = with lib; {
    description = "OCaml module to decode the data of the Unicode character database from its XML representation";
    homepage = webpage;
    inherit (ocaml.meta) platforms;
    maintainers = [ maintainers.vbgl ];
    license = licenses.bsd3;
  };
}
