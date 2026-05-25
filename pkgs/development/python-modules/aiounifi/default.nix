{
  lib,
  aiohttp,
  aioresponses,
  buildPythonPackage,
  fetchFromGitHub,
  orjson,
  pyotp,
  pytest-aiohttp,
  pytest-asyncio,
  pytest-cov-stub,
  pytestCheckHook,
  pythonOlder,
  segno,
  setuptools,
  trustme,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiounifi";
  version = "90";
  pyproject = true;

  disabled = pythonOlder "3.13";

  src = fetchFromGitHub {
    owner = "Kane610";
    repo = "aiounifi";
    tag = "v${finalAttrs.version}";
    hash = "sha256-xM2x4SwVav2gsuG0G1hJjg4AcdsuCYf3O1fma++EYow=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools==82.0.1" "setuptools" \
      --replace-fail "wheel==0.46.3" "wheel"
  '';

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    orjson
    pyotp
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

  pythonImportsCheck = [ "aiounifi" ];

  meta = {
    description = "Python library for communicating with Unifi Controller API";
    homepage = "https://github.com/Kane610/aiounifi";
    changelog = "https://github.com/Kane610/aiounifi/releases/tag/${finalAttrs.src.tag}";
    license = lib.licenses.mit;
    maintainers = [ ];
    mainProgram = "aiounifi";
  };
})
