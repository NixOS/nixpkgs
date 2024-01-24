{ lib
, buildPythonPackage
, fetchFromGitHub
, setuptools
, setuptools-scm
, pytest
, pytestCheckHook
}:

buildPythonPackage {
  pname = "pytest-archon";
  # According to Pypi, it is 0.0.6
  # Using the recommended naming, I get Invalid version: '0.0.6-unstable-2023-12-18'
  version = "0.0.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jwbargsten";
    repo = "pytest-archon";
    rev = "ac5a8763d4fd85f2079f0b8340831fc3e70834e4";
    hash = "sha256-ZKs7ifqgazEywszPGxkcPCf2WD2tEpEsbh8kHN/PL7s=";
  };

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    pytest
  ];

  checkInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pytest_archon" ];

  meta = {
    description = "Rule your architecture like a real developer";
    homepage = "https://github.com/jwbargsten/pytest-archon";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ wolfangaukang ];
  };
}
