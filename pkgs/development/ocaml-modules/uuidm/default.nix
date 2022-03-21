{ lib, stdenv, fetchurl, ocaml, findlib, ocamlbuild, topkg, cmdliner }:

stdenv.mkDerivation rec {
  version = "0.9.7";
  pname = "uuidm";
  src = fetchurl {
    url = "https://erratique.ch/software/uuidm/releases/uuidm-${version}.tbz";
    sha256 = "1ivxb3hxn9bk62rmixx6px4fvn52s4yr1bpla7rgkcn8981v45r8";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild topkg ];
  configurePlatforms = [];
  buildInputs = [ topkg cmdliner ];

  inherit (topkg) buildPhase installPhase;

  meta = with lib; {
    description = "An OCaml module implementing 128 bits universally unique identifiers version 3, 5 (name based with MD5, SHA-1 hashing) and 4 (random based) according to RFC 4122";
    homepage = "https://erratique.ch/software/uuidm";
    license = licenses.bsd3;
    platforms = ocaml.meta.platforms or [];
    maintainers = [ maintainers.maurer ];
  };
}
