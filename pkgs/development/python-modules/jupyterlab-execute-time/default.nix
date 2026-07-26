{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  hatch-jupyter-builder,

  # build inputs
  jupyterlab,
  nodejs,
  writableTmpDirAsHomeHook,
  yarn-berry_3,

  # dependencies
  jupyter-packaging,
}:

buildPythonPackage rec {
  pname = "jupyterlab-execute-time";
  version = "3.3.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "deshaw";
    repo = "jupyterlab-execute-time";
    rev = "v${version}";
    hash = "sha256-1eNv6yTyorg64PXQm68eqp56Ig0eUbhPWluI/s4oijE=";
  };

  # Fix version requirements and replace jupyterlab's pinned yarn (jlpm) with yarn
  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "jupyterlab~=4.0.0" "jupyterlab"
    substituteInPlace pyproject.toml package.json \
      --replace-fail 'jlpm' 'yarn'
  '';

  build-system = [
    hatchling
    hatch-jupyter-builder
  ];

  nativeBuildInputs = [
    jupyterlab
    nodejs
    writableTmpDirAsHomeHook
    yarn-berry_3
    yarn-berry_3.yarnBerryConfigHook
  ];

  offlineCache = yarn-berry_3.fetchYarnBerryDeps {
    yarnLock = "${src}/yarn.lock";
    hash = "sha256-aCuw+4FqA0JPMr++AgE4WI+KmXda1IosaU2yk/vE7vw=";
  };

  dependencies = [
    jupyterlab
    jupyter-packaging
  ];

  pythonImportsCheck = [ "jupyterlab_execute_time" ];

  meta = {
    description = "JupyterLab extension for displaying cell timings";
    homepage = "https://github.com/deshaw/jupyterlab-execute-time";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.vglfr ];
  };
}
