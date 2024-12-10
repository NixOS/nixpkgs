{
  lib,
  fetchurl,
  ppxlib,
  ppx_deriving,
  buildDunePackage,
}:

buildDunePackage rec {
  pname = "sel";
  version = "0.4.0";

  minimalOCamlVersion = "4.07";

  src = fetchurl {
    url = "https://github.com/gares/sel/releases/download/v${version}/sel-${version}.tbz";
    hash = "sha256-Sp0eSeKyFmMvOQrebqLKP+HbHQB0D0eAmEjDzxnFL1I=";
  };

  buildInputs = [
    ppxlib
  ];

  propagatedBuildInputs = [
    ppx_deriving
  ];

  meta = {
    description = "Simple event library";
    homepage = "https://github.com/gares/sel/";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.vbgl ];
  };
}
