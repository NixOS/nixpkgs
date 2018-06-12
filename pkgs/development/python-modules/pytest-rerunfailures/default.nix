{ stdenv, buildPythonPackage, fetchPypi, pytest, mock }:

buildPythonPackage rec {
  pname = "pytest-rerunfailures";
  version = "4.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "be6bf93ed618c8899aeb6721c24f8009c769879a3b4931e05650f3c173ec17c5";
  };

  checkInputs = [ pytest mock ];

  checkPhase = ''
    py.test
  '';

  meta = with stdenv.lib; {
    description = "pytest plugin to re-run tests to eliminate flaky failures.";
    homepage = https://github.com/pytest-dev/pytest-rerunfailures;
    license = licenses.mpl20;
    maintainers = with maintainers; [ jgeerds ];
  };
}
