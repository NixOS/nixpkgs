{ lib, buildPythonPackage, fetchPypi
, jupyter-packaging
}:

buildPythonPackage rec {
  pname = "jupyterlab-widgets";
  version = "3.0.5";

  src = fetchPypi {
    pname = "jupyterlab_widgets";
    inherit version;
    sha256 = "sha256-7q7N6vbAOvyWDdriAc7YjVl5tMqcOJG8uPZjGvcF9e8=";
  };

  nativeBuildInputs = [
    jupyter-packaging
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "jupyterlab_widgets" ];

  meta = with lib; {
    description = "Jupyter Widgets JupyterLab Extension";
    homepage = "https://github.com/jupyter-widgets/ipywidgets";
    license = licenses.bsd3;
    maintainers = with maintainers; [ jonringer SuperSandro2000 ];
  };
}
