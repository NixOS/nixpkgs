{
  lib,
  buildDunePackage,
  fetchurl,
}:

buildDunePackage rec {
  pname = "mmap";
  version = "1.1.0";

  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/mirage/mmap/releases/download/v${version}/mmap-v${version}.tbz";
    sha256 = "0l6waidal2n8mkdn74avbslvc10sf49f5d889n838z03pra5chsc";
  };

  meta = {
    homepage = "https://github.com/mirage/mmap";
    description = "Function for mapping files in memory";
    license = lib.licenses.lgpl21;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
