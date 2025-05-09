{
  lib,
  buildPythonPackage,
  fetchPypi,
  ipywidgets,
  jupyter-packaging,
  jupyterlab,
  setuptools,
}:

buildPythonPackage rec {
  pname = "ipywebrtc";
  version = "0.6.0";
  pyproject = true;

  # Cannot fetch from github (and build javascript from source), as it fails with
  # > Extensions require a devDependency on @jupyterlab/builder@^4.4.1, you have a dependency on 3.0.6
  src = fetchPypi {
    inherit pname version;
    hash = "sha256-+Kw8wCs2M7WfOIrvZ5Yc/1f5ACj9MDuziGxjw9Yx2hM=";
  };

  build-system = [
    jupyter-packaging
    jupyterlab
    setuptools
  ];

  # It seems pythonRelaxDeps doesn't work for these
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "jupyter_packaging~=" "jupyter_packaging>=" \
      --replace-fail "jupyterlab~=" "jupyterlab>="
  '';

  dependencies = [
    ipywidgets
  ];

  # No tests
  doCheck = false;

  pythonImportsCheck = [ "ipywebrtc" ];

  meta = {
    description = "WebRTC and MediaStream API exposed in the Jupyter notebook/lab.";
    homepage = "https://github.com/maartenbreddels/ipywebrtc";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ flokli ];
  };
}
