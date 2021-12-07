{ lib, buildPythonPackage, fetchPypi
, jupyter-packaging
}:

buildPythonPackage rec {
  pname = "jupyterlab-widgets";
  version = "1.0.2";

  src = fetchPypi {
    pname = "jupyterlab_widgets";
    inherit version;
    sha256 = "7885092b2b96bf189c3a705cc3c412a4472ec5e8382d0b47219a66cccae73cfa";
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
