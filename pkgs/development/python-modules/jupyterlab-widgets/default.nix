{ lib, buildPythonPackage, fetchPypi
, jupyter-packaging
}:

buildPythonPackage rec {
  pname = "jupyterlab-widgets";
  version = "3.0.9";
  format = "setuptools";

  src = fetchPypi {
    pname = "jupyterlab_widgets";
    inherit version;
    hash = "sha256-YAWk6XTHvu6EBg/fujQaMhhJUEbeiuPsZIiOX+Gf20w=";
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
    maintainers = with maintainers; [ jonringer ];
  };
}
