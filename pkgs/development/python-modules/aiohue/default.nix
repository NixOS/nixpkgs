{
  lib,
  aiohttp,
  asyncio-throttle,
  awesomeversion,
  buildPythonPackage,
  fetchFromGitHub,
  pytestCheckHook,
  pytest-aiohttp,
  pytest-asyncio,
  pytest-cov-stub,
  pythonOlder,
  setuptools,
}:

buildPythonPackage rec {
  pname = "aiohue";
  version = "4.7.5";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = "aiohue";
    tag = version;
    hash = "sha256-RHWgjugWYJVbzAFhb1bOrm33jZ3MQjkFqUMH+27a6Zw=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail 'version = "0.0.0"' 'version = "${version}"'
  '';

  build-system = [ setuptools ];

  dependencies = [
    awesomeversion
    aiohttp
    asyncio-throttle
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-aiohttp
    pytest-cov-stub
  ];

  pythonImportsCheck = [
    "aiohue"
    "aiohue.discovery"
  ];

  disabledTestPaths = [
    # File are prefixed with test_
    "examples/"
  ];

  meta = with lib; {
    description = "Python package to talk to Philips Hue";
    homepage = "https://github.com/home-assistant-libs/aiohue";
    changelog = "https://github.com/home-assistant-libs/aiohue/releases/tag/${version}";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ fab ];
  };
}
