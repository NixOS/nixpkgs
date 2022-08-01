{ lib, buildDunePackage, fetchurl, base64, either, fmt, jsonm, uutf, optint }:

buildDunePackage rec {
  pname = "repr";
  version = "0.6.0";

  src = fetchurl {
    url = "https://github.com/mirage/${pname}/releases/download/${version}/${pname}-fuzz-${version}.tbz";
    sha256 = "0ph71plf7ffjycgljhbhsnhzzpmd3qkk922rrffw2bq0vya0z2mv";
  };

  minimumOCamlVersion = "4.08";
  useDune2 = true;

  propagatedBuildInputs = [
    base64
    either
    fmt
    jsonm
    uutf
    optint
  ];

  meta = with lib; {
    description = "Dynamic type representations. Provides no stability guarantee";
    homepage = "https://github.com/mirage/repr";
    license = licenses.isc;
    maintainers = with maintainers; [ sternenseemann ];
  };
}
