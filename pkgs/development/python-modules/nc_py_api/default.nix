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
  pname = "nc_py_api";
  version = "0.30.3";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "cloud-py-api";
    repo = "nc_py_api";
    tag = "v${finalAttrs.version}";
    hash = "sha256-MXL8fgMsmZ1UOJoUyeun6WVol1PjsEpfxqDZtofuqZ0=";
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
  # `EnvironmentError` if no server is reachable).  Strip that
  # directory and run only the offline `tests_unit/` subset.
  postPatch = ''
    rm -rf tests
  '';

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
