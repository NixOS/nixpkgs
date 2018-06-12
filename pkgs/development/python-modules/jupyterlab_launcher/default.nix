{ lib, buildPythonPackage, fetchPypi, jsonschema, notebook }:
buildPythonPackage rec {
  pname = "jupyterlab_launcher";
  version = "0.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "2eea0cc95b312e136e6e5abc64e2e62baaeca493cd32f553c2205f79e01c0423";
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
