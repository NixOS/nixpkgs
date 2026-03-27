{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage {
  pname = "dpcontracts";
  version = "unstable-2018-11-20";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "deadpixi";
    repo = "contracts";
    rev = "45cb8542272c2ebe095c6efb97aa9407ddc8bf3c";
    hash = "sha256-FygJPXo7lZ9tlfqY6KmPJ3PLIilMGLBr3013uj9hCEs=";
  };

  # package does not have any tests
  doCheck = false;

  pythonImportsCheck = [ "dpcontracts" ];

  meta = {
    description = "Provides a collection of decorators that makes it easy to write software using contracts";
    homepage = "https://github.com/deadpixi/contracts";
    license = lib.licenses.lgpl3Only;
    maintainers = with lib.maintainers; [ gador ];
  };
}
