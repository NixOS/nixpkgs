{ lib, buildPythonPackage, fetchPypi
, jupyter-packaging
}:

buildPythonPackage rec {
  pname = "jupyterlab-widgets";
  version = "1.0.0";

  src = fetchPypi {
    pname = "jupyterlab_widgets";
    inherit version;
    sha256 = "0y7vhhas3qndiypcpcfnhrj9n92v2w4hdc86nn620s9h9nl2j6jw";
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
