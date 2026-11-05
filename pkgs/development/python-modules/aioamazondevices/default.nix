{
  aiohttp,
  anyio,
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
  version = "17.2.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "chemelli74";
    repo = "aioamazondevices";
    tag = "v${finalAttrs.version}";
    hash = "sha256-i2FPhbgy19ixaPEjDm8nCQlQaB2uauZNmA95fb4jPEM=";
  };

  postPatch = ''
    substituteInPlace pyproject.toml \
      --replace-fail "setuptools>=84.2.1" "setuptools"
  '';

  # all deps are needlessly pinned to very recent versions
  pythonRelaxDeps = true;

  build-system = [ poetry-core ];

  dependencies = [
    aiohttp
    anyio
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
