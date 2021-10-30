{ lib, buildDunePackage, fetchFromGitHub, ocamlnet, cpu }:

buildDunePackage rec {
  pname = "parany";
  version = "12.1.1";

  useDune2 = true;
  minimumOCamlVersion = "4.03.0";

  src = fetchFromGitHub {
    owner = "UnixJunkie";
    repo = pname;
    rev = "v${version}";
    sha256 = "0s2sbmywy4yyh69dcrcqd85hd8jcd7qgfczy79nam4bvn87bjm72";
  };

  propagatedBuildInputs = [ ocamlnet cpu ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Generalized map/reduce for multicore computing";
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.lgpl2;
  };
}
