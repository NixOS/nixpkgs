{ lib
, buildPythonPackage
, fetchPypi
, nbformat
, sphinx
, ipywidgets
, pythonOlder
}:

buildPythonPackage rec {
  pname = "jupyter-sphinx";
  version = "0.2.4";

  src = fetchPypi {
    inherit version;
    pname = "jupyter_sphinx";
    sha256 = "b5ba1efdd1488b385de0068036a665932ed93998e40ce3a342c60f0926781fd9";
  };

  propagatedBuildInputs = [ nbformat sphinx ipywidgets ];

  doCheck = false;

  disabled = pythonOlder "3.5";

  meta = with lib; {
    description = "Jupyter Sphinx Extensions";
    homepage = "https://github.com/jupyter/jupyter-sphinx/";
    license = licenses.bsd3;
  };    

}