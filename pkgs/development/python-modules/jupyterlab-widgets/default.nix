{ lib, buildPythonPackage, fetchPypi
, jupyter-packaging
}:

buildPythonPackage rec {
  pname = "jupyterlab-widgets";
  version = "2.0.0b1";

  src = fetchPypi {
    pname = "jupyterlab_widgets";
    inherit version;
    sha256 = "1xinfk3bhqmfp9ygfpi8b87h4ky8dv3sdr96035psx1jjgyyw8bi";
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
