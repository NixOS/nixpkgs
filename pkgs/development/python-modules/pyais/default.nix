{
  lib,
  stdenv,
  attrs,
  bitarray,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyais";
  version = "2.20.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "M0r13n";
    repo = "pyais";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZyVXZZd9JXTkfucJ5tAcP813FLWapoiTUrzj27SrLlk=";
  };

  __darwinAllowLocalNetworking = true;

  build-system = [ setuptools ];

  dependencies = [
    attrs
    bitarray
  ];

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "pyais" ];

  disabledTestPaths = [
    # Tests the examples which have additional requirements
    "tests/test_examples.py"
  ];

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
    # OSError: [Errno 48] Address already in use
    "test_full_message_flow"
  ];

  meta = {
    description = "Module for decoding and encoding AIS messages (AIVDM/AIVDO)";
    homepage = "https://github.com/M0r13n/pyais";
    changelog = "https://github.com/M0r13n/pyais/blob/${finalAttrs.src.tag}/CHANGELOG.txt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
