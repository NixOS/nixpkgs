{
  lib,
  stdenv,
  buildPythonPackage,
  fetchPypi,
  hatchling,
  hatch-jupyter-builder,
  hatch-nodejs-version,
  jupyterlab,
  ploomber-core,
  pytestCheckHook,
  pytest-jupyter,
}:

buildPythonPackage rec {
  pname = "ploomber-extension";
  version = "0.1.1";
  pyproject = true;

  # using pypi archive which includes pre-built assets
  src = fetchPypi {
    pname = "ploomber_extension";
    inherit version;
    hash = "sha256-wsldqLhJfOESH9aMMzz1Y/FXofHyfgrl81O95NePXSA=";
  };

  build-system = [
    hatchling
    hatch-jupyter-builder
    hatch-nodejs-version
    jupyterlab
  ];

  dependencies = [ ploomber-core ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-jupyter
  ];

  # Tests fail on Darwin when sandboxed
  doCheck = !stdenv.buildPlatform.isDarwin;

  pythonImportsCheck = [ "ploomber_extension" ];

  meta = {
    description = "Ploomber extension";
    homepage = "https://pypi.org/project/ploomber-extension";
    license = lib.licenses.bsd3;
    maintainers = [ lib.maintainers.euxane ];
  };
}
