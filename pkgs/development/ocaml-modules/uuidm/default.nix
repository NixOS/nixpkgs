{ lib, stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg, cmdliner }:

stdenv.mkDerivation rec {
  version = "0.9.8";
  pname = "uuidm";
  src = fetchurl {
    url = "https://erratique.ch/software/uuidm/releases/uuidm-${version}.tbz";
    sha256 = "sha256-/GZbkJVDQu1UY8SliK282kUWAVMfOnpQadUlRT/tJrM=";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild topkg ];
  configurePlatforms = [];
  buildInputs = [ topkg cmdliner ];

  inherit (topkg) buildPhase installPhase;

  meta = with lib; {
    description = "An OCaml module implementing 128 bits universally unique identifiers version 3, 5 (name based with MD5, SHA-1 hashing) and 4 (random based) according to RFC 4122";
    homepage = "https://erratique.ch/software/uuidm";
    license = licenses.bsd3;
    maintainers = [ maintainers.maurer ];
    mainProgram = "uuidtrip";
    inherit (ocaml.meta) platforms;
  };
}
