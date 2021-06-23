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
  version = "3.6.1";
  disabled = pythonOlder "3.6";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2009845554d3169dca99a7397d9904e5dbb58726c7417e8c308dda86f8966311";
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
