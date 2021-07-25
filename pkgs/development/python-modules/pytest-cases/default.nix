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
  version = "3.6.3";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-ExNiaSQGFbx5BB+K+PyW4OPghdpy3SKxhiVFH9okQ7g=";
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
    substituteInPlace setup.cfg --replace "pytest-runner" ""
  '';

  # Tests have dependencies (pytest-harvest, pytest-steps) which
  # are not available in Nixpkgs. Most of the packages (decopatch,
  # makefun, pytest-*) have circular dependecies.
  doCheck = false;

  pythonImportsCheck = [ "pytest_cases" ];

  meta = with lib; {
    description = "Separate test code from test cases in pytest";
    homepage = "https://github.com/smarie/python-pytest-cases";
    license = licenses.bsd3;
    maintainers = with maintainers; [ fab ];
  };
}
