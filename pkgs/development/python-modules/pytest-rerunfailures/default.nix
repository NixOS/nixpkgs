{ stdenv, buildPythonPackage, pythonOlder, fetchPypi, pytest, mock }:

buildPythonPackage rec {
  pname = "pytest-rerunfailures";
  version = "9.1.1";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1cb11a17fc121b3918414eb5eaf314ee325f2e693ac7cb3f6abf7560790827f2";
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
    maintainers = with maintainers; [ das-g ];
  };
}
