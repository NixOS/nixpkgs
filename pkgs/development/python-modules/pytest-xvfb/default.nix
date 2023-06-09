{ lib
, buildPythonPackage
, fetchPypi
, pytest
, pyvirtualdisplay
, isPy27
}:

buildPythonPackage rec {
  pname = "pytest-xvfb";
  version = "3.0.0";
  disabled = isPy27;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-N0arH00RWfA/dRY40FNonM0oQpGzi4+wPT67579pz8A=";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [
    pyvirtualdisplay
  ];

  meta = with lib; {
    description = "A pytest plugin to run Xvfb for tests";
    homepage = "https://github.com/The-Compiler/pytest-xvfb";
    license = licenses.mit;
    maintainers = with maintainers; [ costrouc ];
  };
}
