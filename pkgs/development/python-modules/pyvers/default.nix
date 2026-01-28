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
  version = "0.2.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vmoens";
    repo = "pyvers";
    tag = "v${version}";
    hash = "sha256-VKNwhxyc1f7tyJO7JyBNELlZwVv6U2N8ye0OYFN/nmc=";
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
