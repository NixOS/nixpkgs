{
  lib,
  buildPythonPackage,
  fetchPypi,
  jupyterlab,
  jupyter-packaging,
}:

buildPythonPackage rec {
  pname = "jupyterlab-execute-time";
  version = "3.2.0";
  pyproject = true;

  src = fetchPypi {
    pname = "jupyterlab_execute_time";
    inherit version;
    hash = "sha256-mxO2XCwTm/q7P2/xcGxNM+1aViA6idApdggzThW8nAs=";
  };

  # jupyterlab is required to build from source but we use the pre-build package
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail '"jupyterlab~=4.0.0"' ""
  '';

  dependencies = [
    jupyterlab
    jupyter-packaging
  ];

  # has no tests
  doCheck = false;

  pythonImportsCheck = [ "jupyterlab_execute_time" ];

  meta = {
    description = "JupyterLab extension for displaying cell timings";
    homepage = "https://github.com/deshaw/jupyterlab-execute-time";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.vglfr ];
  };
}
