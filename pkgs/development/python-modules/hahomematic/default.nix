{ lib
, aiohttp
, buildPythonPackage
, fetchFromGitHub
, freezegun
, orjson
, pydevccu
, pytest-aiohttp
, pytestCheckHook
, python-slugify
, pythonOlder
, setuptools
, voluptuous
, websocket-client
, xmltodict
, wheel
}:

buildPythonPackage rec {
  pname = "hahomematic";
  version = "2024.1.8";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "danielperna84";
    repo = "hahomematic";
    rev = "refs/tags/${version}";
    hash = "sha256-ln+Dich2I503LA5nIWK9k3B83LjIBsRUmBv2xJmFRQI=";
  };

  __darwinAllowLocalNetworking = true;

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "setuptools~=68.2" "setuptools" \
      --replace "wheel~=0.41.2" "wheel"
  '';

  nativeBuildInputs = [
    setuptools
    wheel
  ];

  propagatedBuildInputs = [
    aiohttp
    orjson
    python-slugify
    voluptuous
  ];

  nativeCheckInputs = [
    freezegun
    pydevccu
    pytest-aiohttp
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "hahomematic"
  ];

  meta = with lib; {
    description = "Python module to interact with HomeMatic devices";
    homepage = "https://github.com/danielperna84/hahomematic";
    changelog = "https://github.com/danielperna84/hahomematic/releases/tag/${version}";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ fab ];
  };
}
