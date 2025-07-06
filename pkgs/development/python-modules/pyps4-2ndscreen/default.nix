{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  pythonOlder,
  setuptools,
  aiohttp,
  click,
  construct,
  pycryptodomex,
  pytestCheckHook,
  pytest-asyncio,
  asynctest,
}:

buildPythonPackage rec {
  pname = "pyps4-2ndscreen";
  version = "1.3.1";
  pyproject = true;

  disabled = pythonOlder "3.6";

  src = fetchFromGitHub {
    owner = "ktnrg45";
    repo = "pyps4-2ndscreen";
    tag = version;
    hash = "sha256-AXU9WJ7kT/0ev1Cn+CYhEieR7IM5VXebxQYWUS8bdds=";
  };

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    click
    construct
    pycryptodomex
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    asynctest
  ];

  # Disable tests for Python 3.11+ since they all require asynctest
  doCheck = pythonOlder "3.11";

  pythonImportsCheck = [ "pyps4_2ndscreen" ];

  meta = {
    description = "PS4 2nd Screen Python Library";
    homepage = "https://github.com/ktnrg45/pyps4-2ndscreen";
    changelog = "https://github.com/ktnrg45/pyps4-2ndscreen/releases/tag/${version}";
    license = lib.licenses.lgpl2Plus;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
}
