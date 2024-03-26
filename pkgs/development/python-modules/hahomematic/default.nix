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
  version = "2024.3.1";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "danielperna84";
    repo = "hahomematic";
    rev = "refs/tags/${version}";
    hash = "sha256-/ulqUyplNu8YTHJKcfNPYzyzPvGkLFtoJDu5SqvfQrs=";
  };

  __darwinAllowLocalNetworking = true;

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools~=69.1.0" "setuptools" \
      --replace-fail "wheel~=0.42.0" "wheel"
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
    maintainers = with maintainers; [ dotlambda fab ];
  };
}
