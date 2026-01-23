{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # dependencies
  packaging,

  # tests
  jax,
  numpy,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyvers";
  version = "0.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vmoens";
    repo = "pyvers";
    tag = "v${version}";
    hash = "sha256-BUUfb0vI1r/VV5aF9gmqnXGOIWQfBJ98MrcF/IH5CEs=";
  };

  build-system = [
    poetry-core
  ];

  dependencies = [
    packaging
  ];

  pythonImportsCheck = [ "pyvers" ];

  nativeCheckInputs = [
    jax
    numpy
    pytest-cov-stub
    pytestCheckHook
  ];

  meta = {
    description = "Python library for dynamic dispatch based on module versions and backends";
    homepage = "https://github.com/vmoens/pyvers";
    changelog = "https://github.com/vmoens/pyvers/blob/${src.rev}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
}
