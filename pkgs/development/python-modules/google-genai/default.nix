{
  aiohttp,
  anyio,
  buildPythonPackage,
  distro,
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
  sniffio,
  tenacity,
  twine,
  typing-extensions,
  websockets,
}:

buildPythonPackage rec {
  pname = "google-genai";
  version = "1.63.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "python-genai";
    tag = "v${version}";
    hash = "sha256-aTuMvF6ZymKfhw7wjV0flaOW5BD37eNYfAR7IM6BJRg=";
  };

  build-system = [
    packaging
    pkginfo
    setuptools
    twine
  ];

  pythonRelaxDeps = [
    "tenacity"
  ];

  dependencies = [
    anyio
    distro
    google-auth
    httpx
    pydantic
    requests
    sniffio
    tenacity
    typing-extensions
    websockets
  ]
  ++ google-auth.optional-dependencies.requests;

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
