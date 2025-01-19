{
  aiohttp,
  bleak,
  buildPythonPackage,
  fetchFromGitHub,
  hatch-regex-commit,
  hatchling,
  lib,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pynecil";
  version = "4.0.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tr4nt0r";
    repo = "pynecil";
    tag = "v${version}";
    hash = "sha256-mIMtmhnBctymjXlp47YEyW4RXqUU8+YDR/vG/oYSmQI=";
  };

  pythonRelaxDeps = [ "aiohttp" ];

  build-system = [
    hatch-regex-commit
    hatchling
  ];

  dependencies = [
    aiohttp
    bleak
  ];

  pythonImportsCheck = [ "pynecil" ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/tr4nt0r/pynecil/releases/tag/${src.tag}";
    description = "Python library to communicate with Pinecil V2 soldering irons via Bluetooth";
    homepage = "https://github.com/tr4nt0r/pynecil";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
