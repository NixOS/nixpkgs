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
  version = "1.1.4";
  pyproject = true;

  src = fetchFromGitHub {
    owner = "slhck";
    repo = "ffmpeg-progress-yield";
    tag = "v${version}";
    hash = "sha256-78F+ttWM7AHa9LkyG0U/Y4V3yN3yCx3olMR5CgJWnD0=";
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

  disabledTests = lib.optionals stdenv.hostPlatform.isDarwin [
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
