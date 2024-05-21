{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  orjson,
  pytest-aiohttp,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  segno,
  setuptools,
  trustme,
}:

buildPythonPackage rec {
  pname = "aiounifi";
  version = "78";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "Kane610";
    repo = "aiounifi";
    rev = "refs/tags/v${version}";
    hash = "sha256-fY3VsXJfs/uqqQjR6Sp03XlkCOk+8GvXq476dgagJQ8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==" "setuptools>=" \
      --replace-fail "wheel==" "wheel>="

    sed -i '/--cov=/d' pyproject.toml
  '';

  build-system = [ setuptools ];

  dependencies = [
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

  pytestFlagsArray = [ "--asyncio-mode=auto" ];

  pythonImportsCheck = [ "aiounifi" ];

  meta = with lib; {
    description = "Python library for communicating with Unifi Controller API";
    homepage = "https://github.com/Kane610/aiounifi";
    changelog = "https://github.com/Kane610/aiounifi/releases/tag/v${version}";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
    mainProgram = "aiounifi";
  };
}
