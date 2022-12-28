{ lib, buildPythonPackage, fetchPypi
, jupyter-packaging
}:

buildPythonPackage rec {
  pname = "jupyterlab-widgets";
  version = "3.0.3";

  src = fetchPypi {
    pname = "jupyterlab_widgets";
    inherit version;
    sha256 = "sha256-x2cYE5m0yotke+/i2ROxJg9Rv52O+behRjLUwae1Nr0=";
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
