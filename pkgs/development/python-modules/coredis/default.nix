{
  lib,
  async-timeout,
  buildPythonPackage,
  setuptools,
  versioneer,
  deprecated,
  fetchFromGitHub,
  packaging,
  pympler,
  pytest-asyncio,
  pytest-lazy-fixtures,
  pytestCheckHook,
  redis,
  typing-extensions,
  wrapt,
}:

buildPythonPackage rec {
  pname = "coredis";
  version = "4.22.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "alisaifee";
    repo = "coredis";
    tag = version;
    hash = "sha256-EMiZkKUcVbinWtYimNSQ715PH7pCrXpNKqseLFCu/48=";
  };

  postPatch = ''
    sed -i '/mypy==/d' pyproject.toml
    sed -i '/packaging/d' pyproject.toml
    sed -i '/pympler/d' pyproject.toml
    sed -i '/types_deprecated/d' pyproject.toml
    substituteInPlace pytest.ini \
      --replace-fail "-K" ""
  '';

  build-system = [
    setuptools
    versioneer
  ];

  dependencies = [
    async-timeout
    deprecated
    packaging
    pympler
    typing-extensions
    wrapt
  ];

  nativeCheckInputs = [
    pytestCheckHook
    redis
    pytest-asyncio
    pytest-lazy-fixtures
  ];

  pythonImportsCheck = [ "coredis" ];

  pytestFlagsArray = [
    # All other tests require Docker
    "tests/test_lru_cache.py"
    "tests/test_parsers.py"
    "tests/test_retry.py"
    "tests/test_utils.py"
  ];

  meta = {
    description = "Async redis client with support for redis server, cluster & sentinel";
    homepage = "https://github.com/alisaifee/coredis";
    changelog = "https://github.com/alisaifee/coredis/blob/${src.tag}/HISTORY.rst";
    license = lib.licenses.mit;
    teams = [ lib.teams.wdz ];
  };
}
