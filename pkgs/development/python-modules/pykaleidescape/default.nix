{ lib
, aiohttp
, buildPythonPackage
, dnspython
, fetchFromGitHub
, pytest-asyncio
, pytestCheckHook
, pythonOlder
}:

buildPythonPackage rec {
  pname = "pykaleidescape";
  version = "2022.2.3";
  format = "setuptools";

  disabled = pythonOlder "3.7";

  src = fetchFromGitHub {
    owner = "SteveEasley";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-h5G7wV4Z+sf8Qq4GNFsp8DVDSgQgS0dLGf+DzK/egYM=";
  };

  propagatedBuildInputs = [
    aiohttp
    dnspython
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "kaleidescape"
  ];

  disabledTests = [
    # Test requires network access
    "test_resolve_succeeds"
  ];

  meta = with lib; {
    description = "Module for controlling Kaleidescape devices";
    homepage = "https://github.com/SteveEasley/pykaleidescape";
    changelog = "https://github.com/SteveEasley/pykaleidescape/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ fab ];
  };
}
