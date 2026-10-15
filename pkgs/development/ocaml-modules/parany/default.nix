{
  lib,
  buildDunePackage,
  fetchFromGitHub,
  cpu,
}:

buildDunePackage (finalAttrs: {
  pname = "parany";
  version = "14.0.1";

  minimalOCamlVersion = "4.08";

  src = fetchFromGitHub {
    owner = "UnixJunkie";
    repo = "parany";
    rev = "v${finalAttrs.version}";
    hash = "sha256-QR3Rq30iKhft+9tVCgJLOq9bwJe7bcay/kMTXjjCLjE=";
  };

  propagatedBuildInputs = [ cpu ];

  meta = {
    homepage = "https://github.com/UnixJunkie/parany";
    description = "Generalized map/reduce for multicore computing";
    maintainers = [ lib.maintainers.bcdarwin ];
    license = lib.licenses.lgpl2;
  };
})
