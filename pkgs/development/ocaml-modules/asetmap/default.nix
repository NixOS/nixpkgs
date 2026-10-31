{
  lib,
  fetchurl,
  buildDunePackage,
  topkg,
  findlib,
  ocamlbuild,
  ocaml,
}:

buildDunePackage (finalAttrs: {
  pname = "asetmap";
  version = "0.8.1";
  src = fetchurl {
    url = "https://github.com/dbuenzli/asetmap/archive/refs/tags/v${finalAttrs.version}.tar.gz";
    hash = "sha256-MrskBpIs2X1p0YdmSfZX75UOTXFRRxO5jeR2YSbwMxQ=";
  };

  strictDeps = true;

  nativeBuildInputs = [
    topkg
    findlib
    ocamlbuild
    ocaml
  ];
  buildInputs = [ topkg ];

  inherit (topkg) buildPhase installPhase;

  meta = {
    inherit (ocaml.meta) platforms;
    license = lib.licenses.isc;
  };
})
