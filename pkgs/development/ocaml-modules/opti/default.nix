{
  lib,
  fetchurl,
  buildDunePackage,
}:

buildDunePackage rec {
  pname = "opti";
  version = "1.0.3";

  useDune2 = true;

  minimumOCamlVersion = "4.02";

  src = fetchurl {
    url = "https://github.com/magnusjonsson/opti/releases/download/${version}/opti-${version}.tbz";
    sha256 = "ed9ba56dc06e9d2b1bf097964cc65ea37db787d4f239c13d0dd74693f5b50a1e";
  };

  meta = with lib; {
    description = "DSL to generate fast incremental C code from declarative specifications";
    license = licenses.bsd3;
    maintainers = [ maintainers.jmagnusj ];
    homepage = "https://github.com/magnusjonsson/opti";
  };
}
