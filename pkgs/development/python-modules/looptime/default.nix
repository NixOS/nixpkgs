{
  async-timeout,
  buildPythonPackage,
  fetchFromGitHub,
  lib,
  pytest-asyncio,
  pytestCheckHook,
  setuptools,
  setuptools-scm,
  stdenv,
}:

buildPythonPackage (finalAttrs: {
  pname = "looptime";
  version = "0.7";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "nolar";
    repo = "looptime";
    tag = finalAttrs.version;
    hash = "sha256-nQNGE/o5QNAw4OSs+O5oWiq+JX+ShV6njOHkn1IlvtE=";
  };

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonImportsCheck = [ "looptime" ];

  nativeCheckInputs = [
    async-timeout
    pytest-asyncio
    pytestCheckHook
  ];

  disabledTestPaths = lib.optionals stdenv.hostPlatform.isDarwin [
    # Time-based tests that fail pretty predictably on darwin but pass on linux
    "tests/test_chronometers.py::test_duration_resets_on_reuse"
    "tests/test_chronometers.py::test_conversion_to_float"
    "tests/test_chronometers.py::test_sync_context_manager"
    "tests/test_chronometers.py::test_async_context_manager"
    "tests/test_plugin.py::test_fixture_chronometer"
    "tests/test_time_moves.py::test_real_time_is_ignored"
    "tests/test_time_on_executors.py::test_with_sleep"
    "tests/test_time_on_io_idle.py::test_end_of_time"
    "tests/test_time_on_io_idle.py::test_no_idle_configured"
    "tests/test_time_on_io_idle.py::test_stepping_with_no_limit"
  ];

  meta = {
    changelog = "https://github.com/nolar/looptime/releases/tag/${finalAttrs.src.tag}";
    description = "Time dilation & contraction in asyncio event loops (in tests)";
    homepage = "https://github.com/nolar/looptime";
    license = lib.licenses.mit;
    maintainers = [ lib.maintainers.dotlambda ];
  };
})
