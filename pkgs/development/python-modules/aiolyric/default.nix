{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  incremental,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aiolyric";
  version = "2.1.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "timmo001";
    repo = "aiolyric";
    tag = version;
    hash = "sha256-kLsq1pBRWz49DZgX47k132OipDcfn+kby6/GYDL3pPc=";
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

  meta = {
    description = "Python module for the Honeywell Lyric Platform";
    homepage = "https://github.com/timmo001/aiolyric";
    changelog = "https://github.com/timmo001/aiolyric/releases/tag/${src.tag}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
}
