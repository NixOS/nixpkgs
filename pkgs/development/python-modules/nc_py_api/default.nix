{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  hatchling,

  # runtime dependencies
  fastapi,
  filelock,
  niquests,
  pydantic,
  python-dotenv,
  starlette,
  xmltodict,

  # optional dependencies
  uvicorn,
  caldav,

  # tests
  pytest-asyncio,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "nc-py-api";
  version = "0.31.0";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cloud-py-api";
    repo = "nc_py_api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-ZS8oTrSu2T7M/57MDII8IBMmD/m1pu9ydYS31g20sXc=";
  };

  build-system = [ hatchling ];

  dependencies = [
    fastapi
    filelock
    niquests
    pydantic
    python-dotenv
    starlette
    xmltodict
  ];

  optional-dependencies = {
    app = [ uvicorn ];
    calendar = [ caldav ];
  };

  # The integration tests under `tests/` require a live Nextcloud
  # instance (upstream `conftest.py` connects at module load and raises
  # `EnvironmentError` if no server is reachable).  Skip that
  # directory and run only the offline `tests_unit/` subset.
  disabledTestPaths = [
    "tests"
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
  ];

  pythonImportsCheck = [ "nc_py_api" ];

  meta = {
    description = "Nextcloud Python Framework";
    homepage = "https://github.com/cloud-py-api/nc_py_api";
    changelog = "https://github.com/cloud-py-api/nc_py_api/blob/${finalAttrs.src.tag}/CHANGELOG.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ ser ];
    platforms = lib.platforms.unix;
  };
})
