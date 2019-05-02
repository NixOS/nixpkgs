{ stdenv, fetchurl, ocaml, findlib, ocamlbuild, xmlm, topkg }:

let
  pname = "uucd";
  webpage = "https://erratique.ch/software/${pname}";
in
stdenv.mkDerivation rec {
  name = "ocaml-${pname}-${version}";
  version = "10.0.0";

  src = fetchurl {
    url = "${webpage}/releases/${pname}-${version}.tbz";
    sha256 = "0cdyg6vaic4n58w80qriwvaq1c40ng3fh74ilxrwajbq163k055q";
  };

  buildInputs = [ ocaml findlib ocamlbuild topkg ];

  inherit (topkg) buildPhase installPhase;

  propagatedBuildInputs = [ xmlm ];

  meta = with stdenv.lib; {
    description = "An OCaml module to decode the data of the Unicode character database from its XML representation";
    homepage = "${webpage}";
    platforms = ocaml.meta.platforms or [];
    maintainers = [ maintainers.vbgl ];
    license = licenses.bsd3;
  };
}
