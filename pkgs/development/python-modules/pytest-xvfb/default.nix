{
  lib,
  buildPythonPackage,
  fetchPypi,
  pytest,
  pyvirtualdisplay,
  pythonOlder,
}:

buildPythonPackage rec {
  pname = "pytest-xvfb";
  version = "3.0.0";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-N0arH00RWfA/dRY40FNonM0oQpGzi4+wPT67579pz8A=";
  };

  buildInputs = [ pytest ];

  propagatedBuildInputs = [ pyvirtualdisplay ];

  meta = with lib; {
    description = "Pytest plugin to run Xvfb for tests";
    homepage = "https://github.com/The-Compiler/pytest-xvfb";
    changelog = "https://github.com/The-Compiler/pytest-xvfb/blob/v${version}/CHANGELOG.rst";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
