{ lib, stdenv, fetchurl, ocaml, findlib, topkg, ocamlbuild }:

stdenv.mkDerivation rec {
  pname = "ocaml-react";
  version = "1.2.1";

  src = fetchurl {
    url = "https://erratique.ch/software/react/releases/react-${version}.tbz";
    sha256 = "1aj8w79gdd9xnrbz7s5p8glcb4pmimi8jp9f439dqnf6ih3mqb3v";
  };

  nativeBuildInputs = [ ocaml findlib ocamlbuild ];
  buildInputs = [ topkg ];

  strictDeps = true;

  inherit (topkg) buildPhase installPhase;

  meta = with lib; {
    homepage = "https://erratique.ch/software/react";
    description = "Applicative events and signals for OCaml";
    license = licenses.bsd3;
    platforms = ocaml.meta.platforms or [ ];
    maintainers = with maintainers; [ maggesi vbmithr gal_bolle ];
  };
}
