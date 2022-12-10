{ lib, stdenv, fetchurl, ocaml, findlib, ocamlbuild, xmlm, topkg }:

let
  pname = "uucd";
  webpage = "https://erratique.ch/software/${pname}";
in
stdenv.mkDerivation rec {
  name = "ocaml-${pname}-${version}";
  version = "15.0.0";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "sha256-DksDi6Dfe/fNGBmeubwxv9dScTHPJRuaPrlX7M8QRrw=";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild topkg ];
  buildInputs = [ topkg ];

  strictDeps = true;

  inherit (topkg) buildPhase installPhase;

  propagatedBuildInputs = [ xmlm ];

  meta = with lib; {
    description = "An OCaml module to decode the data of the Unicode character database from its XML representation";
    homepage = webpage;
    inherit (ocaml.meta) platforms;
    maintainers = [ maintainers.vbgl ];
    license = licenses.bsd3;
  };
}
