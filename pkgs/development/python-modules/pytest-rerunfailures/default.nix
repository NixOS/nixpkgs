{ lib, buildPythonPackage, pythonOlder, fetchPypi, pytest, mock }:

buildPythonPackage rec {
  pname = "pytest-rerunfailures";
  version = "10.1";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "7617c06de13ee6dd2df9add7e275bfb2bcebbaaf3e450f5937cd0200df824273";
  };

  buildInputs = [ pytest ];

  checkInputs = [ mock pytest ];

  checkPhase = ''
    py.test test_pytest_rerunfailures.py
  '';

  meta = with lib; {
    description = "pytest plugin to re-run tests to eliminate flaky failures";
    homepage = "https://github.com/pytest-dev/pytest-rerunfailures";
    license = licenses.mpl20;
    maintainers = with maintainers; [ das-g ];
  };
}
