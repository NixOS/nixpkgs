{ lib
, buildPythonPackage
, fetchPypi
, pytest
, PyVirtualDisplay
, isPy27
}:

buildPythonPackage rec {
  pname = "pytest-xvfb";
  version = "2.0.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "1kyq5rg27dsnj7dc6x9y7r8vwf8rc88y2ppnnw6r96alw0nn9fn4";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    PyVirtualDisplay
  ];

  meta = with lib; {
    description = "A pytest plugin to run Xvfb for tests";
    homepage = "https://github.com/The-Compiler/pytest-xvfb";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
