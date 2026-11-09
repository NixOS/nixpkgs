{
  lib,
  fetchurl,
  buildTopkgPackage,
}:

buildTopkgPackage rec {
  pname = "asetmap";
  version = "0.8.1";
  src = fetchurl {
    url = "https://github.com/dbuenzli/asetmap/archive/refs/tags/v${version}.tar.gz";
    hash = "sha256-MrskBpIs2X1p0YdmSfZX75UOTXFRRxO5jeR2YSbwMxQ=";
  };

  meta = {
    license = lib.licenses.isc;
  };
}
