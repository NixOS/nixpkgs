{ lib, buildPythonPackage, fetchPypi, jsonschema, notebook, pythonOlder }:
buildPythonPackage rec {
  pname = "jupyterlab_launcher";
  version = "0.13.1";
  disabled = pythonOlder "3.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "f880eada0b8b1f524d5951dc6fcae0d13b169897fc8a247d75fb5beadd69c5f0";
  };

  propagatedBuildInputs = [
    jsonschema
    notebook
  ];

  # depends on requests and a bunch of other libraries
  doCheck = false;

  meta = with lib; {
    description = "This package is used to launch an application built using JupyterLab";
    license = with licenses; [ bsd3 ];
    homepage = "http://jupyter.org/";
    maintainers = with maintainers; [ zimbatm ];
  };
}
