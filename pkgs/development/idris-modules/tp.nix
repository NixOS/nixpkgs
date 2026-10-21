{
  build-idris-package,
  fetchFromGitHub,
  lib,
}:
build-idris-package {
  pname = "tp";
  version = "2017-08-15";

  src = fetchFromGitHub {
    owner = "superfunc";
    repo = "tp";
    rev = "ef59ccf355ae462bd4f55d596e6d03a9376b67b2";
    hash = "sha256-H0XGc9ZSIDfSeOVbr7H3m5yvAS/Dop4CeQ63UDcmIqk=";
  };

  # tests fail with permission error
  doCheck = false;

  meta = {
    description = "Strongly Typed Paths for Idris";
    homepage = "https://github.com/superfunc/tp";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.brainrape ];
  };
}
