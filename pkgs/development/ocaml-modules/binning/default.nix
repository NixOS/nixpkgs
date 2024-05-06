{ lib
, buildDunePackage
, fetchurl
}:

buildDunePackage rec {
  pname = "binning";
  version = "0.0.0";

  minimalOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/pveber/binning/releases/download/v${version}/binning-v${version}.tbz";
    hash = "sha256-eG+xctsbc7lQ5pFOUtJ8rjNW/06gygwLADq7yc8Yf/c=";
  };

  meta = {
    description = "Datastructure to accumulate values in bins";
    license = lib.licenses.cecill-b;
    homepage = "https://github.com/pveber/binning/";
    maintainers = [ lib.maintainers.vbgl ];
  };
}
