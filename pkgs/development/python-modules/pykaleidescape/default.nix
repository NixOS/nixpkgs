{
  lib,
  aiohttp,
  buildPythonPackage,
  dnspython,
  fetchFromGitHub,
  pytest-asyncio_0,
  pytestCheckHook,
  pythonAtLeast,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "pykaleidescape";
  version = "2022.2.3";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "SteveEasley";
    repo = "pykaleidescape";
    tag = "v${version}";
    hash = "sha256-h5G7wV4Z+sf8Qq4GNFsp8DVDSgQgS0dLGf+DzK/egYM=";
  };

  nativeBuildInputs = [ setuptools ];

  propagatedBuildInputs = [
    aiohttp
    dnspython
  ];

  nativeCheckInputs = [
    pytest-asyncio_0
    pytestCheckHook
  ];

  pythonImportsCheck = [ "kaleidescape" ];

  disabledTests = [
    # Test requires network access
    "test_resolve_succeeds"
  ]
  ++ lib.optionals (pythonAtLeast "3.12") [
    # stuck in EpollSelector.poll()
    "test_manual_disconnect"
    "test_concurrency"
  ];

  meta = with lib; {
    description = "Module for controlling Kaleidescape devices";
    homepage = "https://github.com/SteveEasley/pykaleidescape";
    changelog = "https://github.com/SteveEasley/pykaleidescape/releases/tag/${src.tag}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
