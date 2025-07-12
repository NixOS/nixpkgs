{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  orjson,
  pytest-aiohttp,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  segno,
  setuptools,
  trustme,
}:

buildPythonPackage rec {
  pname = "aiounifi";
  version = "84";
  pyproject = true;

  disabled = pythonOlder "3.11";

  src = fetchFromGitHub {
    owner = "Kane610";
    repo = "aiounifi";
    tag = "v${version}";
    hash = "sha256-8zOM1K1N1NFUQwyEVRDFqHntK+HSpXG2F1sRhOs7Bc4=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==80.9.0" "setuptools" \
      --replace-fail "wheel==0.46.1" "wheel"
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
    pytest-cov-stub
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
    maintainers = [ ];
    mainProgram = "aiounifi";
  };
}
