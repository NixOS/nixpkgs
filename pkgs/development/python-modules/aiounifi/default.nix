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
  version = "72";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "Kane610";
    repo = "aiounifi";
    rev = "refs/tags/v${version}";
    hash = "sha256-PrFI5ncHW4r2Re1BIqRZlz8ns6d5p6y6PASCleSmyNc=";
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
    mainProgram = "aiounifi";
    homepage = "https://github.com/Kane610/aiounifi";
    changelog = "https://github.com/Kane610/aiounifi/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
