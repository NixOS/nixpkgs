{ stdenv, buildPythonPackage, fetchPypi, pytest, mock }:

buildPythonPackage rec {
  pname = "pytest-rerunfailures";
  version = "8.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "04p8rfvv7yi3gsdm1dw1mfhjwg6507rhgj7nbm5gfqw4kxmj7h8p";
  };

  checkInputs = [ mock pytest ];

  propagatedBuildInputs = [ pytest ];

  checkPhase = ''
    py.test test_pytest_rerunfailures.py
  '';

  meta = with stdenv.lib; {
    description = "pytest plugin to re-run tests to eliminate flaky failures";
    homepage = https://github.com/pytest-dev/pytest-rerunfailures;
    license = licenses.mpl20;
    maintainers = with maintainers; [ ];
  };
}
