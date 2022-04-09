{ lib, buildDunePackage, fetchFromGitHub, cppo }:

buildDunePackage rec {
  version = "1.2";
  pname = "ocplib-endian";

  src = fetchFromGitHub {
    owner = "OCamlPro";
    repo = "ocplib-endian";
    rev = version;
    sha256 = "sha256-THTlhOfXAPaqTt1qBkht+D67bw6M175QLvXoUMgjks4=";
  };

  minimalOCamlVersion = "4.03";

  nativeBuildInputs = [ cppo ];

  meta = with lib; {
    description = "Optimised functions to read and write int16/32/64";
    homepage = "https://github.com/OCamlPro/ocplib-endian";
    license = licenses.lgpl21;
    maintainers = with maintainers; [ vbgl ];
  };
}
