{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cython,
  mkl,
  nose,
  six,
}:

buildPythonPackage rec {
  pname = "mkl-service";
  version = "2.4.1";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "IntelPython";
    repo = "mkl-service";
    rev = "refs/tags/v${version}";
    sha256 = "sha256-4UPiQt1hVVlPFZnuKlMK3FLv2cIEXToHKxnyYLXR/sY=";
  };

  MKLROOT = mkl;

  nativeCheckInputs = [ nose ];
  nativeBuildInputs = [ cython ];
  propagatedBuildInputs = [
    mkl
    six
  ];

  meta = with lib; {
    description = "Python hooks for Intel(R) Math Kernel Library runtime control settings";
    homepage = "https://github.com/IntelPython/mkl-service";
    license = licenses.bsd3;
    maintainers = with maintainers; [ bhipple ];
  };
}
