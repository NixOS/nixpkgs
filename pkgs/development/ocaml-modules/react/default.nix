{
  lib,
  stdenv,
  fetchurl,
  ocaml,
  findlib,
  topkg,
  ocamlbuild,
}:

stdenv.mkDerivation rec {
  pname = "ocaml-react";
  version = "1.2.2";

  src = fetchurl {
    url = "https://erratique.ch/software/react/releases/react-${version}.tbz";
    sha256 = "sha256-xK3TFdbx8VPRFe58qN1gwSZf9NQIwmYSX8tRJP0ij5k=";
  };

  nativeBuildInputs = [
    ocaml
    findlib
    ocamlbuild
  ];
  buildInputs = [ topkg ];

  strictDeps = true;

  inherit (topkg) buildPhase installPhase;

  meta = with lib; {
    homepage = "https://erratique.ch/software/react";
    description = "Applicative events and signals for OCaml";
    license = licenses.bsd3;
    inherit (ocaml.meta) platforms;
    maintainers = with maintainers; [
      vbmithr
      gal_bolle
    ];
  };
}
