{ lib
, buildPythonPackage
, fetchPypi
, ipywidgets
, ipydatawidgets
}:

buildPythonPackage rec {
  pname = "pythreejs";
  version = "2.3.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "Ixt/ztJIX6CUXgHk3RH7uS1K73Q3al6+bnxADcxOPCU=";
  };
  propagatedBuildInputs = [ ipywidgets ipydatawidgets ];
  pythonImportsCheck = [ "pythreejs" ];
  meta = {
    description = "Interactive 3D graphics for the Jupyter Notebook and JupyterLab, using Three.js and Jupyter Widgets.";
    homepage = "https://github.com/jupyter-widgets/pythreejs";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ cfhammill ];
  };
}
