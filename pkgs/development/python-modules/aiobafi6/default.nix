{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  protobuf,
  pytest-asyncio,
  pytestCheckHook,
  zeroconf,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiobafi6";
  version = "0.10.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "jfroy";
    repo = "aiobafi6";
    tag = finalAttrs.version;
    hash = "sha256-EXLMrZobSICAmWPREjx5D8boj/S/3AH5+lsWQlTCl1g=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    protobuf
    zeroconf
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiobafi6" ];

  meta = {
    description = "Library for communication with the Big Ass Fans i6 firmware";
    homepage = "https://github.com/jfroy/aiobafi6";
    changelog = "https://github.com/jfroy/aiobafi6/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
    mainProgram = "aiobafi6";
  };
})
