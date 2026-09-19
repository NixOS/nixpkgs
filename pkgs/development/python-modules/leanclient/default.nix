{
  lib,
  buildPythonPackage,
  fetchFromGitHub,

  # build-system
  hatchling,

  # dependencies
  orjson,
  psutil,
  tqdm,
  watchfiles,

  # tests
  pytestCheckHook,
  pytest-timeout,
}:

buildPythonPackage (finalAttrs: {
  pname = "leanclient";
  version = "0.13.2";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "oOo0oOo";
    repo = "leanclient";
    tag = "v${finalAttrs.version}";
    hash = "sha256-CFMOMQ0Ar5+zwTOAm8XG15gsytdrKto8RSA5H0Ms7u0=";
  };

  build-system = [ hatchling ];

  dependencies = [
    orjson
    psutil
    tqdm
    watchfiles
  ];

  # pytest-timeout enforces upstream's `timeout = 300`, which matters because
  # the aio tests spawn subprocesses that could otherwise hang a builder.
  nativeCheckInputs = [
    pytestCheckHook
    pytest-timeout
  ];

  # tests/integration and tests/benchmark drive a real Lean project; these do not.
  enabledTestPaths = [
    "tests/unit"
    "tests/aio/test_convert.py"
    "tests/aio/test_fake_server.py"
  ];

  # These four take the test_project_dir fixture, which runs elan and builds
  # Mathlib. Nothing else in the enabled paths needs a Lean toolchain.
  disabledTests = [
    "test_initial_build"
    "test_get_env_as_dict"
    "test_get_env_as_string"
    "test_needs_mathlib_cache_get_real_project"
  ];

  pythonImportsCheck = [
    "leanclient"
    "leanclient.aio"
  ];

  meta = {
    description = "Python client for the Lean theorem prover LSP";
    homepage = "https://github.com/oOo0oOo/leanclient";
    changelog = "https://github.com/oOo0oOo/leanclient/releases/tag/v${finalAttrs.version}";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ remix7531 ];
  };
})
