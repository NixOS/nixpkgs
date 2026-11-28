{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  setuptools-scm,
  blosc2,
  msgpack,
  numpy,
  xxhash,
  medvol,
  jsonschema,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "mlarray";
  version = "1.0.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "MIC-DKFZ";
    repo = "mlarray";
    tag = "v${finalAttrs.version}";
    hash = "sha256-+FEYWBQGs73cFX7SaXdPa7Q1wKNZXauBGkSWpdmLUzc=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  dependencies = [
    blosc2
    msgpack
    numpy
    xxhash
  ];

  optional-dependencies = {
    all = [
      medvol
    ];
  };

  pythonImportsCheck = [
    "mlarray"
  ];

  nativeCheckInputs = [
    pytestCheckHook
    jsonschema
  ];

  meta = {
    description = "Array format specialized for Machine Learning with Blosc2 backend and standardized metadata";
    homepage = "https://github.com/MIC-DKFZ/mlarray";
    changelog = "https://github.com/MIC-DKFZ/mlarray/tags/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ bcdarwin ];
  };
})
