{ lib, buildPythonPackage, fetchPypi, python-language-server }:

buildPythonPackage rec {
  pname = "pyls-spyder";
  version = "0.3.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "07apxh12b8ybkx5izr7pg8kbg5g5wgzw7vh5iy2n8dhiqarzp7s1";
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
