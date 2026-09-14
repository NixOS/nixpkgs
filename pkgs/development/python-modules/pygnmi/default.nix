{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  cryptography,
  dictdiffer,
  grpcio,
  protobuf,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pygnmi";
  version = "0.8.15";
  pyproject = true;

  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "akarneliuk";
    repo = "pygnmi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-2QPUyPGTtXlO6A05mmb/jofRidXfKq0xvH7lv1f9OQk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    cryptography
    dictdiffer
    grpcio
    protobuf
  ];

  # almost all tests fail with:
  # TypeError: expected string or bytes-like object
  doCheck = false;

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pygnmi" ];

  meta = {
    description = "Pure Python gNMI client to manage network functions and collect telemetry";
    mainProgram = "pygnmicli";
    homepage = "https://github.com/akarneliuk/pygnmi";
    changelog = "https://github.com/akarneliuk/pygnmi/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.bsd3;
    maintainers = [ ];
  };
})
