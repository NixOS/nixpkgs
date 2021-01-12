{ lib, buildDunePackage, fetchurl, fmt, uutf, jsonm, base64, either }:

buildDunePackage rec {
  pname = "repr";
  version = "0.2.1";

  minimumOCamlVersion = "4.08";

  src = fetchurl {
    url = "https://github.com/mirage/${pname}/releases/download/${version}/${pname}-fuzz-${version}.tbz";
    sha256 = "1cbzbawbn71mmpw8y84s1p2pbhc055w1znz64jvr00c7fdr9p8hc";
  };

  useDune2 = true;

  propagatedBuildInputs = [
    fmt
    uutf
    jsonm
    base64
    either
  ];

  meta = with lib; {
    description = "Dynamic type representations. Provides no stability guarantee";
    homepage = "https://github.com/mirage/repr";
    license = licenses.isc;
    maintainers = [ maintainers.sternenseemann ];
  };
}
