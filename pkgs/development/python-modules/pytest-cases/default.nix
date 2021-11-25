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
  version = "3.6.5";
  format = "setuptools";

  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-JZfQI6dgYFHWUbCMuHD78eBi9svoV5zkX887V9xFLNw=";
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
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
