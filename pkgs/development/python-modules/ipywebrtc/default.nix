{ lib
, buildPythonPackage
, fetchPypi
, jupyter-packaging
, ipywidgets
, ipython
}:

buildPythonPackage rec {
  pname = "ipywebrtc";
  version = "0.6.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "+Kw8wCs2M7WfOIrvZ5Yc/1f5ACj9MDuziGxjw9Yx2hM=";
  };
  propagatedBuildInputs = [ jupyter-packaging ];
  checkInputs = [ ipython ipywidgets ];
  pythonImportsCheck = [ "ipywebrtc" ];
  meta = {
    description = "WebRTC for Jupyter notebook/lab";
    homepage = "https://github.com/maartenbreddels/ipywebrtc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ cfhammill ];
  };
}
