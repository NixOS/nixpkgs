{ stdenv, buildPythonPackage, fetchPypi, pytest, mock }:

buildPythonPackage rec {
  pname = "pytest-rerunfailures";
  version = "5.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1x7x9khdf78a5j2shx62qc0zgadf6zi943wb3dnaa8g13bngq0an";
  };

  checkInputs = [ mock ];

  propagatedBuildInputs = [ pytest ];

  # disable tests that fail with pytest 3.7.4
  checkPhase = ''
    py.test test_pytest_rerunfailures.py -k 'not test_reruns_with_delay'
  '';

  meta = with stdenv.lib; {
    description = "pytest plugin to re-run tests to eliminate flaky failures.";
    homepage = https://github.com/pytest-dev/pytest-rerunfailures;
    license = licenses.mpl20;
    maintainers = with maintainers; [ jgeerds ];
  };
}
