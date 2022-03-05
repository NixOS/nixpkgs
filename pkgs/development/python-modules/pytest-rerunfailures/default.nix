{ lib, buildPythonPackage, pythonOlder, fetchPypi, pytest, mock }:

buildPythonPackage rec {
  pname = "pytest-rerunfailures";
  version = "10.2";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9e1e1bad51e07642c5bbab809fc1d4ec8eebcb7de86f90f1a26e6ef9de446697";
  };

  buildInputs = [ pytest ];

  checkInputs = [ mock pytest ];

  checkPhase = ''
    py.test test_pytest_rerunfailures.py
  '';

  meta = with lib; {
    description = "Pytest plugin to re-run tests to eliminate flaky failures";
    homepage = "https://github.com/pytest-dev/pytest-rerunfailures";
    license = licenses.mpl20;
    maintainers = with maintainers; [ das-g ];
  };
}
