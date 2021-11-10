{ lib, buildDunePackage, fetchzip, cppo }:

buildDunePackage rec {
  version = "1.1";
  pname = "ocplib-endian";

  src = fetchzip {
    url = "https://github.com/OCamlPro/ocplib-endian/archive/${version}.tar.gz";
    sha256 = "sha256-zKsSkhlZBXSqPtw+/WN3pwo9plM9rDZfMbGVfosqb10=";
  };

  useDune2 = true;

  nativeBuildInputs = [ cppo ];

  meta = with lib; {
    description = "Optimised functions to read and write int16/32/64";
    homepage = "https://github.com/OCamlPro/ocplib-endian";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ vbgl ];
  };
}
