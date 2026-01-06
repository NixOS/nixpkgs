{
  lib,
  base36,
  buildPythonPackage,
  chacha20poly1305-reuseable,
  cryptography,
  fetchFromGitHub,
  h11,
  orjson,
  pyqrcode,
  pytest-asyncio,
  pytest-timeout,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  setuptools,
  zeroconf,
}:

buildPythonPackage rec {
  pname = "hap-python";
  version = "5.0.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "ikalchev";
    repo = "HAP-python";
    tag = version;
    hash = "sha256-+EhxoO5X/ANGh008WE0sJeBsu8SRnuds3hXGxNWpKnk=";
  };

  build-system = [ setuptools ];

  dependencies = [
    chacha20poly1305-reuseable
    cryptography
    h11
    orjson
    zeroconf
  ];

  optional-dependencies.QRCode = [
    base36
    pyqrcode
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytest-timeout
    pytestCheckHook
  ]
  ++ optional-dependencies.QRCode;

  pythonImportsCheck = [ "pyhap" ];

  disabledTests = lib.optionals (pythonAtLeast "3.14") [
    # https://github.com/ikalchev/HAP-python/issues/490
    "test_start_from_sync"
  ];

  meta = {
    description = "HomeKit Accessory Protocol implementation";
    homepage = "https://github.com/ikalchev/HAP-python";
    changelog = "https://github.com/ikalchev/HAP-python/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ oro ];
  };
}
