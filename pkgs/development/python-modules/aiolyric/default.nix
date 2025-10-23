{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  incremental,
  pythonOlder,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aiolyric";
  version = "2.0.2";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "timmo001";
    repo = "aiolyric";
    tag = version;
    hash = "sha256-k0UE9SXHS8lPu3kC+tGtn99rCU2hq+fdCsp6f83+gv4=";
  };

  build-system = [
    incremental
    setuptools
  ];

  dependencies = [
    aiohttp
    incremental
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiolyric" ];

  disabledTestPaths = [
    # _version file is no shipped
    "tests/test__version.py"
  ];

  meta = with lib; {
    description = "Python module for the Honeywell Lyric Platform";
    homepage = "https://github.com/timmo001/aiolyric";
    changelog = "https://github.com/timmo001/aiolyric/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
