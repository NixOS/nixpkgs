{
  lib,
  anyio,
  beartype,
  buildPythonPackage,
  hatchling,
  hatch-mypyc,
  hatch-vcs,
  types-deprecated,
  deprecated,
  exceptiongroup,
  fetchFromGitHub,
  packaging,
  pytest-asyncio,
  pytest-lazy-fixtures,
  pytest-mock,
  pytestCheckHook,
  redis,
  typing-extensions,
}:

buildPythonPackage (finalAttrs: {
  pname = "coredis";
  version = "6.6.1";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alisaifee";
    repo = "coredis";
    tag = finalAttrs.version;
    hash = "sha256-Jn6tqMpyk849/hwYM0DHuQnGbMltRpTXAVcN5Kt6lk4=";
  };

  postPatch = ''
    sed -i '/mypy==/d' pyproject.toml
    sed -i '/hatch-mypy/d' pyproject.toml
    sed -i '/opentelemetry-sdk/d' pyproject.toml
    substituteInPlace pyproject.toml \
      --replace-fail '"-K"' ""
  '';

  build-system = [
    hatchling
    hatch-mypyc
    hatch-vcs
    types-deprecated
  ];

  dependencies = [
    anyio
    beartype
    deprecated
    exceptiongroup
    packaging
    typing-extensions
  ];

  nativeCheckInputs = [
    pytestCheckHook
    redis
    pytest-asyncio
    pytest-lazy-fixtures
    pytest-mock
  ];

  pythonImportsCheck = [ "coredis" ];

  enabledTestPaths = [
    # All other tests require Docker
    "tests/test_lru_cache.py"
    "tests/test_parsers.py"
    "tests/test_retry.py"
    "tests/test_utils.py"
  ];

  meta = {
    description = "Async redis client with support for redis server, cluster & sentinel";
    homepage = "https://github.com/alisaifee/coredis";
    changelog = "https://github.com/alisaifee/coredis/blob/${finalAttrs.src.tag}/HISTORY.rst";
    license = lib.licenses.mit;
  };
})
