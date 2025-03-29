{
  lib,
  buildPythonPackage,
  pythonOlder,
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
  disabled = pythonOlder "3.6";

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

  pythonImportsCheck = [ "ploomber_extension" ];

  meta = with lib; {
    description = "Ploomber extension";
    homepage = "https://pypi.org/project/ploomber-extension";
    license = licenses.bsd3;
    maintainers = with maintainers; [ euxane ];
  };
}
