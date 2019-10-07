{ lib, fetchFromGitHub, buildDunePackage
, calendar, csv, hex, re
}:

buildDunePackage rec {
  pname = "pgocaml";
  version = "4.0";
  src = fetchFromGitHub {
    owner = "darioteixeira";
    repo = "pgocaml";
    rev = "v${version}";
    sha256 = "1s8c5prr7jb9k76bz990m836czm6k8rv5bvp6s2zg9ra0w19w90j";
  };

  minimumOCamlVersion = "4.05";

  preConfigure = "patchShebangs src/genconfig.sh";

  propagatedBuildInputs = [ calendar csv hex re ];

  meta = with lib; {
    description = "An interface to PostgreSQL databases for OCaml applications";
    inherit (src.meta) homepage;
    license = licenses.lgpl2;
    maintainers = with maintainers; [ vbgl ];
  };
}
