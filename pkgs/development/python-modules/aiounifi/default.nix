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
, wheel
}:

buildPythonPackage rec {
  pname = "aiounifi";
  version = "63";
  format = "pyproject";

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "Kane610";
    repo = pname;
    rev = "refs/tags/v${version}";
    hash = "sha256-am11pFgYMRccUNaK/iKdp6mfk5NQ4QnU41xbFiGCMPs=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace "setuptools==" "setuptools>=" \
      --replace "wheel==" "wheel>="

    sed -i '/--cov=/d' pyproject.toml
  '';

  nativeBuildInputs = [
    setuptools
    wheel
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
    maintainers = with maintainers; [ peterhoeg ];
  };
}
