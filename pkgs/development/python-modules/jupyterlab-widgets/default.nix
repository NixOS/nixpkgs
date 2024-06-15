{
  lib,
  buildPythonPackage,
  fetchPypi,
  jupyter-packaging,
}:

buildPythonPackage rec {
  pname = "jupyterlab-widgets";
  version = "3.0.11";
  pyproject = true;

  src = fetchPypi {
    pname = "jupyterlab_widgets";
    inherit version;
    hash = "sha256-3VrGeVk8lprynJvtBUwk8mhCuqUTUhFHNnVrwDXe7ic=";
  };

  # jupyterlab is required to build from source but we use the pre-build package
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"jupyterlab~=4.0"' ""
  '';

  nativeBuildInputs = [ jupyter-packaging ];

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
