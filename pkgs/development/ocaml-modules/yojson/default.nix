{
  lib,
  fetchurl,
  buildDunePackage,
  seq,
}:

buildDunePackage rec {
  pname = "yojson";
  version = "3.0.0";

  src = fetchurl {
    url = "https://github.com/ocaml-community/yojson/releases/download/${version}/yojson-${version}.tbz";
    hash = "sha256-mUFNp2CbkqAkdO9LSezaFe3Iy7pSKTQbEk5+RpXDlhA=";
  };

  propagatedBuildInputs = [ seq ];

  meta = with lib; {
    description = "Optimized parsing and printing library for the JSON format";
    homepage = "https://github.com/ocaml-community/${pname}";
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
    mainProgram = "ydump";
  };
}
