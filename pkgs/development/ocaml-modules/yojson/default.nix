{ lib, fetchurl, buildDunePackage, cppo, seq }:

buildDunePackage rec {
  pname = "yojson";
  version = "2.1.0";

  src = fetchurl {
    url = "https://github.com/ocaml-community/yojson/releases/download/${version}/yojson-${version}.tbz";
    sha256 = "sha256-n8sf8ttYqyWfkih5awraR5Tq6XF3sYMzcTgMTk+QsV0=";
  };

  nativeBuildInputs = [ cppo ];
  propagatedBuildInputs = [ seq ];

  meta = with lib; {
    description = "An optimized parsing and printing library for the JSON format";
    homepage = "https://github.com/ocaml-community/${pname}";
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
    mainProgram = "ydump";
  };
}
