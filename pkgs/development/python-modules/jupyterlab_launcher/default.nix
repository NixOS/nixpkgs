{ lib, buildPythonPackage, fetchPypi, jsonschema, notebook }:
buildPythonPackage rec {
  pname = "jupyterlab_launcher";
  version = "0.11.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "236a647f4c3f8417413643a918a893a5f662fb5d2fdccce2fd101e3cca2e7fd1";
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
