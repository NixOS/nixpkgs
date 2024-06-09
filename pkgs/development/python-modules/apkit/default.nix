{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  numpy,
  scipy,
}:

buildPythonPackage {
  pname = "apkit";
  version = "unstable-2022-08-23";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "hwp";
    repo = "apkit";
    rev = "40561738c3f585c590c3f0584bf2e3354eefbd48";
    hash = "sha256-/pwoEKB6BD+wWy7QwPwwzSxGn+TAOaMzduOXyuoXC8g=";
  };

  propagatedBuildInputs = [
    numpy
    scipy
  ];

  pythonImportsCheck = [ "apkit" ];

  # This package has no tests
  doCheck = false;

  meta = with lib; {
    description = "Audio processing toolkit";
    homepage = "https://github.com/hwp/apkit";
    license = licenses.mit;
    maintainers = with maintainers; [ GaetanLepage ];
  };
}
