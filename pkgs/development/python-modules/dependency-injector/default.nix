{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  cython,
  setuptools,

  # optional-dependencies
  aiohttp,
  pydantic,
  flask,
  pyyaml,

  # tests
  fastapi,
  httpx,
  mypy-boto3-s3,
  numpy,
  pytest-asyncio,
  pytestCheckHook,
  scipy,
}:

buildPythonPackage (finalAttrs: {
  pname = "dependency-injector";
  version = "4.49.1";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "ets-labs";
    repo = "python-dependency-injector";
    tag = finalAttrs.version;
    hash = "sha256-ncxKYzkV10hA2D8U1/zvkYJ/VFhNUsvRaOBNjzhIdtA=";
  };

  build-system = [
    cython
    setuptools
  ];

  optional-dependencies = {
    aiohttp = [ aiohttp ];
    pydantic = [ pydantic ];
    flask = [ flask ];
    yaml = [ pyyaml ];
  };

  nativeCheckInputs = [
    fastapi
    httpx
    mypy-boto3-s3
    numpy
    pytest-asyncio
    pytestCheckHook
    scipy
  ]
  ++ lib.concatAttrValues finalAttrs.passthru.optional-dependencies;

  pythonImportsCheck = [ "dependency_injector" ];

  disabledTestPaths = [
    # Exclude tests for EOL Python releases
    "tests/unit/ext/test_aiohttp_py35.py"
    "tests/unit/wiring/test_*_py36.py"
    "tests/unit/providers/configuration/test_from_pydantic_py36.py"
    "tests/unit/providers/configuration/test_pydantic_settings_in_init_py36.py"

    # Requires unpackaged fast-depends
    "tests/unit/wiring/test_fastdepends.py"
  ];

  meta = {
    description = "Dependency injection microframework for Python";
    homepage = "https://github.com/ets-labs/python-dependency-injector";
    changelog = "https://github.com/ets-labs/python-dependency-injector/blob/${finalAttrs.src.tag}/docs/main/changelog.rst";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ gerschtli ];
  };
})
