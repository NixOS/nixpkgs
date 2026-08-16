{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  poetry-core,

  # tests
  jax,
  numpy,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyvers";
  version = "0.2.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "vmoens";
    repo = "pyvers";
    tag = "v${finalAttrs.version}";
    hash = "sha256-aXHOgKd/w1RKdL0wLoM4F05JWTaKAL3i3UerLcBG+vs=";
  };

  build-system = [
    poetry-core
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
    changelog = "https://github.com/vmoens/pyvers/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
