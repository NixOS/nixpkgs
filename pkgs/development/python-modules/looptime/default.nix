{
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
}:

buildPythonPackage (finalAttrs: {
  pname = "looptime";
  version = "0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nolar";
    repo = "looptime";
    tag = finalAttrs.version;
    hash = "sha256-nQNGE/o5QNAw4OSs+O5oWiq+JX+ShV6njOHkn1IlvtE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonImportsCheck = [ "looptime" ];

  nativeCheckInputs = [
    async-timeout
    pytest-asyncio
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/nolar/looptime/releases/tag/${finalAttrs.src.tag}";
    description = "Time dilation & contraction in asyncio event loops (in tests)";
    homepage = "https://github.com/nolar/looptime";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
