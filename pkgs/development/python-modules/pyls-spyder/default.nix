{ lib, buildPythonPackage, fetchPypi, python-language-server }:

buildPythonPackage rec {
  pname = "pyls-spyder";
  version = "0.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f2be1b05f2c7a72565b28de7289d2c2b16052b88e46914279a2d631e074ed158";
  };

  propagatedBuildInputs = [ python-language-server ];

  # no tests
  doCheck = false;
  pythonImportsCheck = [ "pyls_spyder" ];

  meta = with lib; {
    description = "Spyder extensions for the python-language-server";
    homepage = "https://github.com/spyder-ide/pyls-spyder";
    license = licenses.mit;
    maintainers = with maintainers; [ SuperSandro2000 ];
  };
}
