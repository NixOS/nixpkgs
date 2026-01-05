{
  lib,
  aiohttp,
  attrs,
  buildPythonPackage,
  fetchFromGitHub,
  fetchpatch,
  setuptools,
}:

buildPythonPackage rec {
  pname = "eternalegypt";
  version = "0.0.16";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "amelchio";
    repo = "eternalegypt";
    tag = "v${version}";
    hash = "sha256-ubKepd3yBaoYrIUe5WCt1zd4CjvU7SeftOR+2cBaEf0=";
  };

  patches = [
    # https://github.com/amelchio/eternalegypt/pull/38
    (fetchpatch {
      name = "move-from-async_timeout.timeout-to-asyncio.timeout.patch";
      url = "https://github.com/amelchio/eternalegypt/commit/f496ae2d38b5d4a3f676310b5bb45c7c34b5262f.patch";
      hash = "sha256-8AHFEP/2yMeyoSWCxNyG+ARS7T40hkEwJ/rp9S8ouSE=";
    })
  ];

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    attrs
  ];

  # Project has no tests
  doCheck = false;

  pythonImportsCheck = [ "eternalegypt" ];

  meta = with lib; {
    description = "Python API for Netgear LTE modems";
    homepage = "https://github.com/amelchio/eternalegypt";
    changelog = "https://github.com/amelchio/eternalegypt/releases/tag/v${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
