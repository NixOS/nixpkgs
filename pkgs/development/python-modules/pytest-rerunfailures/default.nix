{ stdenv, buildPythonPackage, fetchPypi, pytest, mock }:

buildPythonPackage rec {
  pname = "pytest-rerunfailures";
  version = "4.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "97216f8a549f74da3cc786236d9093fbd43150a6fbe533ba622cb311f7431774";
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
