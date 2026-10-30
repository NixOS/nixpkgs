{
  lib,
  aiohttp,
  aiomqtt,
  buildPythonPackage,
  certifi,
  fetchFromGitHub,
  openssl,
  orjson,
  pytest-cov-stub,
  pytestCheckHook,
  setuptools,
}:

buildPythonPackage (finalAttrs: {
  pname = "aiovitesy";
  version = "1.4.6";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chemelli74";
    repo = "aiovitesy";
    tag = "v${finalAttrs.version}";
    hash = "sha256-3foOe9xv6quyGwWroeaebtHEDuGdS840U6VbJZku/+8=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=84.2.1" "setuptools"
  '';

  pythonRelaxDeps = [
    "aiohttp"
    "certifi"
    "orjson"
  ];

  build-system = [ setuptools ];

  dependencies = [
    aiohttp
    aiomqtt
    certifi
    orjson
  ];

  nativeCheckInputs = [
    openssl
    pytest-cov-stub
    pytestCheckHook
  ];

  pythonImportsCheck = [ "aiovitesy" ];

  meta = {
    description = "Python library to control Vitesy devices";
    homepage = "https://github.com/chemelli74/aiovitesy";
    changelog = "https://github.com/chemelli74/aiovitesy/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.asl20;
    maintainers = [ lib.maintainers.jamiemagee ];
  };
})
