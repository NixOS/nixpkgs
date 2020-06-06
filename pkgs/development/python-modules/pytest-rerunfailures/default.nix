{ stdenv, buildPythonPackage, fetchPypi, pytest, mock }:

buildPythonPackage rec {
  pname = "pytest-rerunfailures";
  version = "9.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "895ac2a6486c0da0468ae31768b818d9f3f7fceddef110970c7dbb09e7b4b8e4";
  };

  checkInputs = [ mock pytest ];

  propagatedBuildInputs = [ pytest ];

  checkPhase = ''
    py.test test_pytest_rerunfailures.py
  '';

  meta = with stdenv.lib; {
    description = "pytest plugin to re-run tests to eliminate flaky failures";
    homepage = "https://github.com/pytest-dev/pytest-rerunfailures";
    license = licenses.mpl20;
    maintainers = with maintainers; [ ];
  };
}
