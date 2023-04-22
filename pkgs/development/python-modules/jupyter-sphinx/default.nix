{ lib
, buildPythonPackage
, fetchPypi
, nbformat
, sphinx
, ipywidgets
, pythonOlder
, nbconvert
}:

buildPythonPackage rec {
  pname = "jupyter-sphinx";
  version = "0.4.0";

  src = fetchPypi {
    inherit version;
    pname = "jupyter_sphinx";
    hash = "sha256-DBGjjxNDE48sUFHA00xMVF9EgBdMG9QcAlb+gm4LqlU=";
  };

  propagatedBuildInputs = [ nbconvert nbformat sphinx ipywidgets ];

  doCheck = false;

  disabled = pythonOlder "3.5";

  meta = with lib; {
    description = "Jupyter Sphinx Extensions";
    homepage = "https://github.com/jupyter/jupyter-sphinx/";
    license = licenses.bsd3;
  };

}
