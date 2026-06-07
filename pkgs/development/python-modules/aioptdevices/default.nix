{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  aiohttp,
  orjson,
  pytest-aiohttp,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "aioptdevices";
  version = "2026.7.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ParemTech-Inc";
    repo = "aioptdevices";
    tag = "v2026.07.1";
    hash = "sha256-6vF64lmPSU95YpkrqNh5jAWnoUHZqXn7WK9xtc4sKs8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ", 'versioningit'" "" \
      --replace-fail 'dynamic = ["version"]' 'version = "${finalAttrs.version}"'

    # test_connection.py imports secret.py at module level. It holds live API
    # credentials and is gitignored upstream, so create a stub to allow collection
    echo 'TOKEN = "token"' > tests/secret.py
    echo 'DEVICE_ID = "device-id"' >> tests/secret.py
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    orjson
  ];

  nativeCheckInputs = [
    pytest-aiohttp
    pytest-asyncio
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aioptdevices" ];

  disabledTests = [
    # require network access and live API credentials
    "test_real_server"
    "test_real_server_multi"
  ];

  meta = {
    description = "Fetch PTDevices information from the PTDevices servers";
    homepage = "https://github.com/ParemTech-Inc/aioptdevices";
    changelog = "https://github.com/ParemTech-Inc/aioptdevices/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.gpl3Only;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
