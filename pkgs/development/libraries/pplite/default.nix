{
  stdenv,
  lib,
  fetchurl,
  flint,
  gmp,
}:

stdenv.mkDerivation {
  pname = "pplite";
  version = "0.11";

  src = fetchurl {
    url = "https://github.com/ezaffanella/PPLite/raw/main/releases/pplite-0.11.tar.gz";
    hash = "sha256-6IS5zVab8X+gnhK8/qbPH5FODFaG6vIsIG9TTEpfHEI=";
  };

  buildInputs = [
    flint
    gmp
  ];

  meta = {
    homepage = "https://github.com/ezaffanella/PPLite";
    description = "Convex polyhedra library for Abstract Interpretation";
    mainProgram = "pplite_lcdd";
    license = lib.licenses.gpl3Only;
  };
}
