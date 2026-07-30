{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,
  numpy,
  setuptools,

  # dependencies
  scipy,

  # tests
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "numpy-quaternion";
  version = "2024.0.13";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "moble";
    repo = "quaternion";
    tag = "v${finalAttrs.version}";
    hash = "sha256-W35R+S6yzcKTpKtemjiLzH9v5owduUtos9DyoY28qbc=";
  };

  build-system = [
    hatchling
    numpy
    setuptools
  ];

  dependencies = [
    numpy
    scipy
  ];

  pythonImportsCheck = [ "quaternion" ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  meta = {
    description = "Built-in support for quaternions in numpy";
    homepage = "https://github.com/moble/quaternion";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
