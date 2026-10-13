{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  setuptools,

  # dependencies
  absl-py,
  jax,
  numpy,

  # tests
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "jmp";
  version = "0.0.4";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "deepmind";
    repo = "jmp";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+PefZU1209vvf1SfF8DXiTvKYEnZ4y8iiIr8yKikx9Y=";
  };

  build-system = [
    setuptools
  ];

  dependencies = [
    numpy
    # Not listed in `dependencies` but in practice is necessary to import jmp
    absl-py
    jax
  ];

  pythonImportsCheck = [ "jmp" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  meta = {
    description = "This library implements support for mixed precision training in JAX";
    homepage = "https://github.com/deepmind/jmp";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ ndl ];
  };
})
