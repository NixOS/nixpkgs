{ lib, buildPythonPackage, fetchPypi, jsonschema, notebook }:
buildPythonPackage rec {
  pname = "jupyterlab_launcher";
  version = "0.10.5";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1v1ir182zm2dl14lqvqjhx2x40wnp0i32n6rldxnm1allfpld1n7";
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
