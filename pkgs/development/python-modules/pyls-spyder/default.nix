{ lib, buildPythonPackage, fetchPypi, python-language-server }:

buildPythonPackage rec {
  pname = "pyls-spyder";
  version = "0.4.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "45a321c83f64267d82907492c55199fccabda45bc872dd23bf1efd08edac1b0b";
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
