{
  lib,
  aiohttp,
  aioresponses,
  asynccmd,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  poetry-core,
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage rec {
  pname = "pyspcwebgw";
  version = "0.7.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "mbrrg";
    repo = "pyspcwebgw";
    tag = "v${version}";
    hash = "sha256-gdIrbr25GXaX26B1f7u0NKbqqnAC2tmMFZspzW6I4HI=";
  };

  patches = [
    # https://github.com/pyspcwebgw/pyspcwebgw/pull/27
    (fetchpatch {
      name = "replace-async-timeout-with-asyncio.timeout.patch";
      url = "https://github.com/pyspcwebgw/pyspcwebgw/commit/22cacc8db53cf2a244c30c0e62a0dad90fbcb00b.patch";
      hash = "sha256-Og0imZts49jwjbz7Yp41UIzwU/lVjKVc/Tp4+vNz32U=";
    })
  ];

  build-system = [ poetry-core ];

  dependencies = [
    asynccmd
    aiohttp
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "pyspcwebgw" ];

  meta = with lib; {
    description = "Python module for the SPC Web Gateway REST API";
    homepage = "https://github.com/mbrrg/pyspcwebgw";
    changelog = "https://github.com/pyspcwebgw/pyspcwebgw/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
