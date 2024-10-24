{
  lib,
  attrs,
  buildPythonPackage,
  fetchPypi,

  # build-system
  poetry-core,
  poetry-dynamic-versioning,

  # dependencies
  pytest,
  ruff,
}:

buildPythonPackage rec {
  pname = "pytest-ruff";
  version = "0.4.1";
  pyproject = true;

  src = fetchPypi {
    inherit version;
    pname = "pytest_ruff";
    hash = "sha256-LJow8V84TCKciBtS7IbPrx5505Uw3X3V8tauviePfrc=";
  };

  build-system = [
    poetry-core
    poetry-dynamic-versioning
  ];

  dependencies = [
    pytest
    ruff
  ];

  nativeBuildInputs = [
    ruff
  ];

  pythonImportsCheck = [ "pytest_ruff" ];

  meta = {
    description = "A pytest plugin to run ruff";
    homepage = "https://github.com/businho/pytest-ruff";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ baloo ];
  };
}
