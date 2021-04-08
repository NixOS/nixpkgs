{ lib, buildPythonPackage, fetchPypi, jupyter-packaging }:

buildPythonPackage rec {
  pname = "jupyterlab-widgets";
  version = "1.0.0";

  src = fetchPypi {
    inherit version;
    pname = "jupyterlab_widgets";
    sha256 = "0y7vhhas3qndiypcpcfnhrj9n92v2w4hdc86nn620s9h9nl2j6jw";
  };

  buildInputs = [ jupyter-packaging ];

  pythonImportsCheck = [ "jupyterlab_widgets" ];

  meta = {
    description = "Interactive Widgets for the Jupyter Notebook ";
    homepage = "https://github.com/jupyter-widgets/ipywidgets";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ jluttine ];
  };
}
