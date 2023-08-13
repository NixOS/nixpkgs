{ lib, buildDunePackage, fetchFromGitHub, cpu }:

buildDunePackage rec {
  pname = "parany";
  version = "14.0.0";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "UnixJunkie";
    repo = pname;
    rev = "v${version}";
    hash = "sha256-L5jHm3gZ2XIJ7jMUb/KvpSa/bnprEX75/P3BCMSe9Ok=";
  };

  propagatedBuildInputs = [ cpu ];

  meta = with lib; {
    homepage = "https://github.com/UnixJunkie/parany";
    description = "Generalized map/reduce for multicore computing";
    maintainers = [ maintainers.bcdarwin ];
    license = licenses.lgpl2;
  };
}
