{ lib, fetchurl, buildDunePackage, cppo, easy-format, biniou }:

buildDunePackage rec {
  pname = "yojson";
  version = "2.0.1";
  useDune2 = true;

  src = fetchurl {
    url = "https://github.com/ocaml-community/yojson/releases/download/${version}/yojson-${version}.tbz";
    sha256 = "sha256-i8i8cipKlGVqWDlPF/n4pAYmc0Orh9dyAtuTBYSgyDY=";
  };

  nativeBuildInputs = [ cppo ];
  propagatedBuildInputs = [ easy-format biniou ];

  meta = with lib; {
    description = "An optimized parsing and printing library for the JSON format";
    homepage = "https://github.com/ocaml-community/${pname}";
    license = licenses.bsd3;
    maintainers = [ maintainers.vbgl ];
    mainProgram = "ydump";
  };
}
