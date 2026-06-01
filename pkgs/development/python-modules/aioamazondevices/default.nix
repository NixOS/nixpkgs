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

buildPythonPackage rec {
  pname = "aioamazondevices";
  version = "13.8.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chemelli74";
    repo = "aioamazondevices";
    tag = "v${version}";
    hash = "sha256-pDD5MYOW1EfxX8CQ/fUirUhR2I3Kr3IxTMaembOnljM=";
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
    changelog = "https://github.com/chemelli74/aioamazondevices/blob/${src.tag}/CHANGELOG.md";
    description = "Python library to control Amazon devices";
    homepage = "https://github.com/chemelli74/aioamazondevices";
    license = lib.licenses.asl20;
    maintainers = with lib.maintainers; [ dotlambda ];
  };
}
