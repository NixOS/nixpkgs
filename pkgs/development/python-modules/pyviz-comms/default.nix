{
  buildPythonPackage,
  fetchPypi,
  hatch-jupyter-builder,
  hatch-nodejs-version,
  hatchling,
  lib,
  param,
  panel,
}:

buildPythonPackage rec {
  pname = "pyviz-comms";
  version = "3.0.3";
  pyproject = true;

  src = fetchPypi {
    pname = "pyviz_comms";
    inherit version;
    hash = "sha256-/eSgF8IhPs7mOppnQUMchF5CpcexWI5Ke6LkNwxYNyg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"jupyterlab>=4.0.0,<5",' ""
  '';

  build-system = [
    hatch-jupyter-builder
    hatch-nodejs-version
    hatchling
  ];

  dependencies = [ param ];

  # there are not tests with the package
  doCheck = false;

  pythonImportsCheck = [ "pyviz_comms" ];

  passthru.tests = {
    inherit panel;
  };

  meta = {
    description = "Bidirectional communication for the HoloViz ecosystem";
    homepage = "https://pyviz.org/";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
}
