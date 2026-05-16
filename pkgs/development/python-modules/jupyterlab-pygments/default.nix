{
  lib,
  buildPythonPackage,
  fetchPypi,
  hatch-jupyter-builder,
  hatch-nodejs-version,
  hatchling,
  pygments,
}:

buildPythonPackage rec {
  pname = "jupyterlab-pygments";
  version = "0.3.0";
  pyproject = true;

  src = fetchPypi {
    pname = "jupyterlab_pygments";
    inherit version;
    hash = "sha256-chrKTZApJSsRz6nRheW1r01Udyu4By+bcDb0FwBU010=";
  };

  # jupyterlab is not necessary since we get the source from pypi
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace '"jupyterlab>=4.0.0,<5",' ""
  '';

  nativeBuildInputs = [
    hatch-jupyter-builder
    hatch-nodejs-version
    hatchling
  ];

  # no tests exist on upstream repo
  doCheck = false;

  propagatedBuildInputs = [ pygments ];

  pythonImportsCheck = [ "jupyterlab_pygments" ];

  meta = {
    description = "Jupyterlab syntax coloring theme for pygments";
    homepage = "https://github.com/jupyterlab/jupyterlab_pygments";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
