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
  version = "1.61.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "python-genai";
    tag = "v${version}";
    hash = "sha256-21E3Aksi3W74ZLg79rSJJ00FCwAjTUiNQ9uq0TSJ7+s=";
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
