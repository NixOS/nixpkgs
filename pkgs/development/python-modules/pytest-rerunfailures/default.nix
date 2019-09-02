{ stdenv, buildPythonPackage, fetchPypi, pytest, mock }:

buildPythonPackage rec {
  pname = "pytest-rerunfailures";
  version = "7.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1zfm9v80bqfdapygy9wmi6j6y5c179ixpnh9ih27py4v6cqwzjgk";
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
    maintainers = with maintainers; [ jgeerds ];
  };
}
