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
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "aioskybell";
  version = "23.12.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "tkdrob";
    repo = "aioskybell";
    tag = finalAttrs.version;
    hash = "sha256-5F0B5z0pJLKJPzKIowE07vEgmNXnDVEeGFbPGnJ6H9I=";
  };

  postPatch = ''
    substituteInPlace setup.py \
      --replace 'version="master",' 'version="${finalAttrs.version}",'
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

  meta = {
    description = "API client for Skybell doorbells";
    homepage = "https://github.com/tkdrob/aioskybell";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fab ];
  };
})
