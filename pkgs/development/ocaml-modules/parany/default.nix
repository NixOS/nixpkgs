{ lib, buildDunePackage, fetchFromGitHub, ocamlnet, cpu }:

buildDunePackage rec {
  pname = "parany";
  version = "12.0.3";

  useDune2 = true;
  minimumOCamlVersion = "4.03.0";

  src = fetchFromGitHub {
    owner = "UnixJunkie";
    repo = pname;
    rev = "v${version}";
    sha256 = "1j962ak68kvv62bczjqxwlwvdgcvjfcs36qwq12nnm0pwlzkhg33";
  };

  propagatedBuildInputs = [ ocamlnet cpu ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Generalized map/reduce for multicore computing";
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.lgpl2;
  };
}
