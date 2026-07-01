{
  aiohttp,
  beautifulsoup4,
  buildPythonPackage,
  fetchFromGitHub,
  httpx,
  langcodes,
  lib,
  orjson,
  poetry-core,
  pytest-cov-stub,
  pytestCheckHook,
  python-dateutil,
}:

buildPythonPackage (finalAttrs: {
  pname = "aioamazondevices";
  version = "14.1.8";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chemelli74";
    repo = "aioamazondevices";
    tag = "v${finalAttrs.version}";
    hash = "sha256-54nlWZGLYTHbieVtYqUyP1Y3VZ98NhDEnmSzx+cPfJQ=";
  };

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    beautifulsoup4
    httpx
    langcodes
    orjson
    python-dateutil
  ]
  ++ httpx.optional-dependencies.http2;

  pythonImportsCheck = [ "aioamazondevices" ];

  nativeCheckInputs = [
    pytest-cov-stub
    pytestCheckHook
  ];

  meta = {
    changelog = "https://github.com/chemelli74/aioamazondevices/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    description = "Python library to control Amazon devices";
    homepage = "https://github.com/chemelli74/aioamazondevices";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
})
