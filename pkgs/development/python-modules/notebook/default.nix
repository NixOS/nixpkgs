{ stdenv
, lib
, buildPythonPackage
, pythonOlder
, fetchPypi
, hatch-jupyter-builder
, hatchling
, jupyter-server
, jupyterlab
, jupyterlab-server
, notebook-shim
, tornado
, pytest-jupyter
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "notebook";
  version = "7.0.6";
  disabled = pythonOlder "3.8";

  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-7GETsGUpAZ9/KHgZrwbJeiuvepWsIaj24yGSiY6fmlg=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "timeout = 300" ""
  '';

  nativeBuildInputs = [
    hatch-jupyter-builder
    hatchling
    jupyterlab
  ];

  propagatedBuildInputs = [
    jupyter-server
    jupyterlab
    jupyterlab-server
    notebook-shim
    tornado
  ];

  nativeCheckInputs = [
    pytest-jupyter
    pytestCheckHook
  ];

  pytestFlagsArray = [
    "-W" "ignore::DeprecationWarning"
  ];

  env = {
    JUPYTER_PLATFORM_DIRS = 1;
  };

  # Some of the tests use localhost networking.
  __darwinAllowLocalNetworking = true;

  meta = {
    changelog = "https://github.com/jupyter/notebook/blob/v${version}/CHANGELOG.md";
    description = "Web-based notebook environment for interactive computing";
    homepage = "https://github.com/jupyter/notebook";
    license = lib.licenses.bsd3;
    maintainers = lib.teams.jupyter.members;
    mainProgram = "jupyter-notebook";
  };
}
