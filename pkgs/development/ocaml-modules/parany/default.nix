{ lib, buildDunePackage, fetchFromGitHub, ocamlnet, cpu }:

buildDunePackage rec {
  pname = "parany";
  version = "12.1.2";

  useDune2 = true;
  minimumOCamlVersion = "4.03.0";

  src = fetchFromGitHub {
    owner = "UnixJunkie";
    repo = pname;
    rev = "v${version}";
    sha256 = "yOeJzb2Wr6jA4efI9/fuqDCl/Tza3zxT3YjAiJmhHHg=";
  };

  propagatedBuildInputs = [ ocamlnet cpu ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Generalized map/reduce for multicore computing";
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.lgpl2;
  };
}
