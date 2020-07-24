{ stdenv, buildPythonPackage, pythonOlder, fetchPypi, pytest, mock }:

buildPythonPackage rec {
  pname = "pytest-rerunfailures";
  version = "9.0";

  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1r5qnkkhkfvx1jbi1wfyxpyggwyr32w6h5z3i93a03bc92kc4nl9";
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
