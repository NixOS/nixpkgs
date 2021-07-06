{ lib, buildDunePackage, fetchurl, base64, either, fmt, jsonm, uutf }:

buildDunePackage rec {
  pname = "repr";
  version = "0.3.0";

  src = fetchurl {
    url = "https://github.com/mirage/${pname}/releases/download/${version}/${pname}-fuzz-${version}.tbz";
    sha256 = "sha256-2b0v5RwutvyidzEDTEb5p33IvJ+3t2IW+KVxYD1ufXQ=";
  };

  minimumOCamlVersion = "4.08";
  useDune2 = true;

  propagatedBuildInputs = [
    base64
    either
    fmt
    jsonm
    uutf
  ];

  meta = with lib; {
    description = "Dynamic type representations. Provides no stability guarantee";
    homepage = "https://github.com/mirage/repr";
    license = licenses.isc;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
