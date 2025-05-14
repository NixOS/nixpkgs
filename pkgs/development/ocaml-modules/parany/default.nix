{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  cpu,
}:

buildDunePackage rec {
  pname = "parany";
  version = "14.0.1";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "UnixJunkie";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-QR3Rq30iKhft+9tVCgJLOq9bwJe7bcay/kMTXjjCLjE=";
  };

  propagatedBuildInputs = [ cpu ];

  meta = with lib; {
    homepage = "https://github.com/UnixJunkie/parany";
    description = "Generalized map/reduce for multicore computing";
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.lgpl2;
  };
}
