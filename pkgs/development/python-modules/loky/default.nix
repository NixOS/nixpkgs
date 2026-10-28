{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  procps,

  # build-system
  setuptools,

  # dependencies
  cloudpickle,

  # tests
  packaging,
  psutil,
  pytestCheckHook,
}:

buildPythonPackage (finalAttrs: {
  pname = "loky";
  version = "3.7.0";
  pyproject = true;
  __structuredAttrs = true;

  src = fetchFromGitHub {
    owner = "joblib";
    repo = "loky";
    tag = finalAttrs.version;
    hash = "sha256-4THM0g6H5fCHRbjyatXtalL7jeAFZKAMoUr/IIDBsX8=";
  };

  postPatch =
    # `pgrep` is only packaged for Linux: on darwin, `procps` is the `unixtools` stub which merely
    # provides `ps`, `sysctl`, `top` and `watch`.
    # There, leave the lookup to PATH so that the system `/usr/bin/pgrep` is used.
    lib.optionalString stdenv.hostPlatform.isLinux ''
      substituteInPlace loky/backend/utils.py \
        --replace-fail \
          '"pgrep"' \
          '"${lib.getExe' procps "pgrep"}"'
    '';

  build-system = [
    setuptools
  ];

  dependencies = [
    cloudpickle
  ];

  pythonImportsCheck = [ "loky" ];

  nativeCheckInputs = [
    packaging
    psutil
    pytestCheckHook
  ];

  disabledTests = [
    # FileNotFoundError: [Errno 2] No such file or directory: ''
    "test_resource_tracker"

    # Sends 2.2GB through a pipe and can exceed the 60s faulthandler timeout on busy builders
    "test_no_failure_on_large_data_send"
  ]
  ++ lib.optionals stdenv.hostPlatform.isDarwin [
    # Flaky: AssertionError: Executor took too long to shutdown
    "test_first_exception_some_already_complete"
    # Exercises the `pgrep` fallback, which is unavailable in the darwin sandbox
    "test_kill_process_tree"
    # PermissionError: [Errno 13] Permission denied: '/tmp/foobar'
    "test_sync_object_handling"
  ];

  meta = {
    description = "Robust and reusable Executor for joblib";
    homepage = "https://github.com/joblib/loky";
    changelog = "https://github.com/joblib/loky/blob/${finalAttrs.src.tag}/CHANGES.md";
    license = lib.licenses.bsd3;
    maintainers = with lib.maintainers; [ GaetanLepage ];
  };
})
