{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
}:

buildPythonPackage rec {
  pname = "pyflexit";
  version = "0.3";
  format = "setuptools";

  src = fetchFromGitHub {
    owner = "Sabesto";
    repo = "pyflexit";
    rev = version;
    hash = "sha256-L+I1yJUHg76BjN9+zUnqsiO4p7v8fky1d0R+80fGVKo=";
  };

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "pyflexit" ];

  meta = {
    description = "Python library for Flexit A/C units";
    homepage = "https://github.com/Sabesto/pyflexit";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
