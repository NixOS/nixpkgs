{
  lib,
  build-idris-package,
  fetchFromGitHub,
}:

build-idris-package {
  pname = "tf-random";
  version = "2020-01-15";

  src = fetchFromGitHub {
    owner = "david-christiansen";
    repo = "idris-tf-random";
    rev = "202aac3b96757e8247f6e26945329d90dd668aed";
    hash = "sha256-tOM5tJ8sosd3P5/RNHYFWhMC0ZgmwaHZ1brNUHX2F/0=";
  };

  meta = {
    description = "Port of Haskell tf-random";
    homepage = "https://github.com/david-christiansen/idris-tf-random";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.mikesperber ];
  };
}
