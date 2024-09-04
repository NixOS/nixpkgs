{
  lib,
  buildPythonPackage,
  fetchPypi,
  jupyterlab,
  jupyter-packaging,
}:

buildPythonPackage rec {
  pname = "jupyterlab-execute-time";
  version = "3.1.2";
  pyproject = true;

  src = fetchPypi {
    pname = "jupyterlab_execute_time";
    inherit version;
    hash = "sha256-DiyGsoNXXh+ieMfpSrA6A/5c0ftNV9Ygs9Tl2/VEdbk=";
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
