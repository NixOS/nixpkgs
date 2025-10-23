{
  lib,
  aenum,
  buildPythonPackage,
  fetchFromGitHub,
  aiohttp,
  aioresponses,
  hatchling,
  pydantic,
  pytest-asyncio,
  pytest-httpx,
  pytestCheckHook,
  pythonOlder,
  rich,
}:

buildPythonPackage rec {
  pname = "intellifire4py";
  version = "4.2.1";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "jeeftor";
    repo = "intellifire4py";
    tag = "v${version}";
    hash = "sha256-kCZkIR8SmrLTm86M87juV7oQ+O01AA4pzkBMnKCnbNA=";
  };

  build-system = [ hatchling ];

  dependencies = [
    aiohttp
    aenum
    pydantic
    rich
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytest-httpx
    pytestCheckHook
  ];

  pythonImportsCheck = [ "intellifire4py" ];

  meta = with lib; {
    description = "Module to read Intellifire fireplace status data";
    homepage = "https://github.com/jeeftor/intellifire4py";
    changelog = "https://github.com/jeeftor/intellifire4py/releases/tag/v${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
    mainProgram = "intellifire4py";

  };
}
