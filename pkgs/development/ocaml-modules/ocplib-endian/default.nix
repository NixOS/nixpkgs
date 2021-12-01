{ lib, buildDunePackage, fetchFromGitHub, cppo }:

buildDunePackage rec {
  version = "1.1";
  pname = "ocplib-endian";

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = "ocplib-endian";
    rev = version;
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
