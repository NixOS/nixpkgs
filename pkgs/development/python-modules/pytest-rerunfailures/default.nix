{ lib, buildPythonPackage, pythonOlder, fetchPypi, pytest, mock }:

buildPythonPackage rec {
  pname = "pytest-rerunfailures";
  version = "10.3";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-2CRNeZ+Jpu215XMB3a6ztvENZpFjjVHoCzcTEVkuKMY=";
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
