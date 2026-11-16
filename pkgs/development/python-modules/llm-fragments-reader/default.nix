{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  httpx,
  httpx-sse,
  llm,
  llm-fragments-reader,
  pytestCheckHook,
  pytest-asyncio,
  pytest-httpx,
  writableTmpDirAsHomeHook,
}:

buildPythonPackage rec {
  pname = "llm-fragments-reader";
  version = "0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "simonw";
    repo = "llm-fragments-reader";
    tag = version;
    hash = "sha256-2xdvOpMGsTtnerrlGiVSHoJrM+GQ7Zgv+zn2SAwYAL4=";
  };

  build-system = [ setuptools ];

  dependencies = [ llm ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-httpx
    writableTmpDirAsHomeHook
  ];

  pythonImportsCheck = [ "llm_fragments_reader" ];

  passthru.tests = llm.mkPluginTest llm-fragments-reader;

  meta = {
    description = "Run URLs through the Jina Reader API";
    homepage = "https://github.com/simonw/llm-fragments-reader";
    changelog = "https://github.com/simonw/llm-fragments-reader/releases/tag/${version}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ philiptaron ];
  };
}
