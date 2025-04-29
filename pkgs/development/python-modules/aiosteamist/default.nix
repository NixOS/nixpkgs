{
  lib,
  aiohttp,
  buildPythonPackage,
  fetchFromGitHub,
  poetry-core,
  pytestCheckHook,
  pytest-cov-stub,
  pythonOlder,
  xmltodict,
}:

buildPythonPackage rec {
  pname = "aiosteamist";
  version = "1.0.1";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "bdraco";
    repo = "aiosteamist";
    tag = "v${version}";
    hash = "sha256-e7Nt/o2A1qn2nSpWv6ZsZHn/WpcXKzol+f+JNJaSb4w=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    xmltodict
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-cov-stub
  ];

  pythonImportsCheck = [ "aiosteamist" ];

  meta = with lib; {
    description = "Module to control Steamist steam systems";
    homepage = "https://github.com/bdraco/aiosteamist";
    changelog = "https://github.com/bdraco/aiosteamist/releases/tag/v${version}";
    license = licenses.asl20;
    maintainers = with maintainers; [ fab ];
  };
}
