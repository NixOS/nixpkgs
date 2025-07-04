{
  lib,
  anyio,
  buildPythonPackage,
  dirty-equals,
  distro,
  fetchFromGitHub,
  hatch-fancy-pypi-readme,
  hatchling,
  httpx,
  nest-asyncio,
  pydantic,
  pytest-asyncio,
  pytestCheckHook,
  respx,
  sniffio,
  typing-extensions,
}:

buildPythonPackage rec {
  pname = "groq";
  version = "0.19.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "groq";
    repo = "groq-python";
    tag = "v${version}";
    hash = "sha256-+1us/LPQEMeswxxHvydfTCod+RimUD2lKtlAZ3pDZOA=";
  };

  build-system = [
    hatch-fancy-pypi-readme
    hatchling
  ];

  dependencies = [
    anyio
    distro
    httpx
    pydantic
    sniffio
    typing-extensions
  ];

  nativeCheckInputs = [
    dirty-equals
    nest-asyncio
    pytest-asyncio
    pytestCheckHook
    respx
  ];

  pythonImportsCheck = [ "groq" ];

  disabledTests = [
    # Tests require network access
    "test_method"
    "test_streaming"
    "test_raw_response"
    "test_copy_build_request"
  ];

  meta = {
    description = "Library for the Groq API";
    homepage = "https://github.com/groq/groq-python";
    changelog = "https://github.com/groq/groq-python/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ fab ];
  };
}
