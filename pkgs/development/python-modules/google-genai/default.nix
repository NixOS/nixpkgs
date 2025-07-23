{
  aiohttp,
  anyio,
  buildPythonPackage,
  fetchFromGitHub,
  google-auth,
  httpx,
  lib,
  packaging,
  pkginfo,
  pydantic,
  pytestCheckHook,
  requests,
  setuptools,
  twine,
  typing-extensions,
  websockets,
}:

buildPythonPackage rec {
  pname = "google-genai";
  version = "1.20.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "python-genai";
    tag = "v${version}";
    hash = "sha256-7DwLIK3/VCVSt9lq0Q0IRbhfLXOWw1TbPpDgI4jr9cg=";
  };

  build-system = [
    packaging
    pkginfo
    setuptools
    twine
  ];

  pythonRelaxDeps = [ "websockets" ];

  dependencies = [
    anyio
    google-auth
    httpx
    pydantic
    requests
    typing-extensions
    websockets
  ];

  optional-dependencies = {
    aiohttp = [ aiohttp ];
  };

  pythonImportsCheck = [ "google.genai" ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  # ValueError: GOOGLE_GENAI_REPLAYS_DIRECTORY environment variable is not set
  doCheck = false;

  meta = {
    changelog = "https://github.com/googleapis/python-genai/blob/${src.tag}/CHANGELOG.md";
    description = "Google Generative AI Python SDK";
    homepage = "https://github.com/googleapis/python-genai";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
