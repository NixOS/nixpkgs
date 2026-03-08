{
  lib,
  fetchurl,
  buildTopkgPackage,
}:

buildTopkgPackage rec {
  pname = "htmlit";
  version = "0.2.0";

  minimalOCamlVersion = "4.14.0";

  src = fetchurl {
    url = "https://erratique.ch/software/htmlit/releases/htmlit-${version}.tbz";
    hash = "sha256-i+7gYle8G2y78GeoAnlNY5dpdONLhltuswusCbMmB/c=";
  };

  meta = {
    description = "HTML generation combinators for OCaml";
    homepage = "https://erratique.ch/software/htmlit";
    license = lib.licenses.isc;
    maintainers = with lib.maintainers; [ redianthus ];
  };
}
