{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  uv-build,
  tqdm,
  pytest-asyncio,
  pytestCheckHook,
  ffmpeg,
  procps,
  versionCheckHook,
}:

buildPythonPackage rec {
  pname = "ffmpeg-progress-yield";
  version = "1.0.5";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "slhck";
    repo = "ffmpeg-progress-yield";
    tag = "v${version}";
    hash = "sha256-L3q0Tyh0e1qBV13NRlFxjS/39uKfJWVeN/AGXH+Jss8=";
  };

  build-system = [ uv-build ];

  dependencies = [
    tqdm
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    ffmpeg
    procps
  ];

  disabledTests = lib.optional stdenv.hostPlatform.isDarwin [
    # cannot access /usr/bin/pgrep from the sandbox
    "test_context_manager"
    "test_context_manager_with_exception"
    "test_automatic_cleanup_on_exception"
    "test_async_context_manager"
    "test_async_context_manager_with_exception"
    "test_async_automatic_cleanup_on_exception"
  ];

  pythonImportsCheck = [ "ffmpeg_progress_yield" ];

  nativeInstallCheckInputs = [ versionCheckHook ];
  doInstallCheck = true;

  meta = {
    description = "Run an ffmpeg command with progress";
    mainProgram = "ffmpeg-progress-yield";
    homepage = "https://github.com/slhck/ffmpeg-progress-yield";
    changelog = "https://github.com/slhck/ffmpeg-progress-yield/blob/${src.tag}/CHANGELOG.md";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ prusnak ];
  };
}
