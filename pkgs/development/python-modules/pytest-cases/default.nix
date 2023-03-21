{ lib
, buildPythonPackage
, fetchPypi
, makefun
, decopatch
, pythonOlder
, pytest
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "pytest-cases";
  version = "3.6.14";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-dFXmylelRMG/3YtWrOCMHBzkxlcqiquPG9NR3CWhC2s=";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  buildInputs = [
    pytest
  ];

  propagatedBuildInputs = [
    decopatch
    makefun
  ];

  postPatch = ''
    substituteInPlace setup.cfg \
      --replace "pytest-runner" ""
  '';

  # Tests have dependencies (pytest-harvest, pytest-steps) which
  # are not available in Nixpkgs. Most of the packages (decopatch,
  # makefun, pytest-*) have circular dependecies.
  doCheck = false;

  pythonImportsCheck = [
    "pytest_cases"
  ];

  meta = with lib; {
    description = "Separate test code from test cases in pytest";
    homepage = "https://github.com/smarie/python-pytest-cases";
    changelog = "https://github.com/smarie/python-pytest-cases/releases/tag/${version}";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
