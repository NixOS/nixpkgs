{ lib, buildDunePackage, fetchurl, base64, either, fmt, jsonm, uutf }:

buildDunePackage rec {
  pname = "repr";
  version = "0.4.0";

  src = fetchurl {
    url = "https://github.com/mirage/${pname}/releases/download/${version}/${pname}-fuzz-${version}.tbz";
    sha256 = "1kpwgncyxcrq90dn7ilja7c5i88whc3fz4fmq1lwr0ar95d7d48p";
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
