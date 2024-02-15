{ lib
, aiohttp
, aioresponses
, buildPythonPackage
, fetchFromGitHub
, orjson
, pytest-aiohttp
, pytest-asyncio
, pytestCheckHook
, pythonOlder
, segno
, setuptools
, trustme
}:

buildPythonPackage rec {
  pname = "aiounifi";
  version = "70";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "Kane610";
    repo = "aiounifi";
    rev = "refs/tags/v${version}";
    hash = "sha256-yLqGqRWzuMqymGqGR1mA4oQb+tWt58lA7C/kXC5bYz8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "setuptools==" "setuptools>=" \
      --replace "wheel==" "wheel>="

    sed -i '/--cov=/d' pyproject.toml
  '';

  nativeBuildInputs = [
    setuptools
  ];

  propagatedBuildInputs = [
    aiohttp
    orjson
    segno
  ];

  nativeCheckInputs = [
    aioresponses
    pytest-aiohttp
    pytest-asyncio
    pytestCheckHook
    trustme
  ];

  pytestFlagsArray = [
    "--asyncio-mode=auto"
  ];

  pythonImportsCheck = [
    "aiounifi"
  ];

  meta = with lib; {
    description = "Python library for communicating with Unifi Controller API";
    homepage = "https://github.com/Kane610/aiounifi";
    changelog = "https://github.com/Kane610/aiounifi/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
