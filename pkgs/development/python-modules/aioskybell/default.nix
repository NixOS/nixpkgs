{
  lib,
  aiofiles,
  aiohttp,
  aresponses,
  buildPythonPackage,
  ciso8601,
  fetchFromGitHub,
  pytest-asyncio,
  pytest-freezegun,
  pytestCheckHook,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aioskybell";
  version = "23.12.0";
  pyproject = true;

  disabled = pythonOlder "3.9";

  src = fetchFromGitHub {
    owner = "tkdrob";
    repo = "aioskybell";
    rev = "refs/tags/${version}";
    hash = "sha256-5F0B5z0pJLKJPzKIowE07vEgmNXnDVEeGFbPGnJ6H9I=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'version="master",' 'version="${version}",'
  '';

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    aiohttp
    aiofiles
    ciso8601
  ];

  nativeCheckInputs = [
    aresponses
    pytest-asyncio
    pytest-freezegun
    pytestCheckHook
  ];

  disabledTests = [
    # aiohttp compat issues
    "test_get_devices"
    "test_errors"
    "test_async_change_setting"
  ];

  pythonImportsCheck = [ "aioskybell" ];

  meta = with lib; {
    description = "API client for Skybell doorbells";
    homepage = "https://github.com/tkdrob/aioskybell";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
