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
  version = "2026.3.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ParemTech-Inc";
    repo = "aioptdevices";
    tag = "v2026.03.2";
    hash = "sha256-nsGolkZFQsDrQPG+xcNvtyY9ZWuY/0I3/M+spxAVJJc=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail ", 'Cython>=3.0.2', 'versioningit'" "" \
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
