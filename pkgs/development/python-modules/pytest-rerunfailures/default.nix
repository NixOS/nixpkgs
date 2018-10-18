{ stdenv, buildPythonPackage, fetchPypi, pytest, mock }:

buildPythonPackage rec {
  pname = "pytest-rerunfailures";
  version = "4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "be6bf93ed618c8899aeb6721c24f8009c769879a3b4931e05650f3c173ec17c5";
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
