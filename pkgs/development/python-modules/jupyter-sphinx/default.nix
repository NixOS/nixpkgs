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
  version = "0.3.2";

  src = fetchPypi {
    inherit version;
    pname = "jupyter_sphinx";
    sha256 = "37fc9408385c45326ac79ca0452fbd7ae2bf0e97842d626d2844d4830e30aaf2";
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
