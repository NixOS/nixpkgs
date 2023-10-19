{ lib
, aiohttp
, asyncio-throttle
, awesomeversion
, buildPythonPackage
, fetchFromGitHub
, pytestCheckHook
, pytest-aiohttp
, pytest-asyncio
, pythonOlder
, setuptools
}:

buildPythonPackage rec {
  pname = "aiohue";
  version = "4.7.0";
  pyproject = true;

  disabled = pythonOlder "3.10";

  src = fetchFromGitHub {
    owner = "home-assistant-libs";
    repo = pname;
    rev = "refs/tags/${version}";
    hash = "sha256-t48rUPAM0XpbDreCwHU/smoyhPtxhwrpDkb1170GkQM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace 'version = "0.0.0"' 'version = "${version}"'
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    awesomeversion
    aiohttp
    asyncio-throttle
  ];

  nativeCheckInputs = [
    pytestCheckHook
    pytest-asyncio
    pytest-aiohttp
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
