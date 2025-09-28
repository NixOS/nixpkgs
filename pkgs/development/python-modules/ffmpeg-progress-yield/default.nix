{
  lib,
  stdenv,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  tqdm,
  pytest-asyncio,
  pytestCheckHook,
  pythonOlder,
  ffmpeg,
  procps,
}:

buildPythonPackage rec {
  pname = "ffmpeg-progress-yield";
  version = "1.0.2";
  pyproject = true;

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "slhck";
    repo = "ffmpeg-progress-yield";
    tag = "v${version}";
    hash = "sha256-tX4CioyhZvHNe5PItNwCF68ZQhs4fpG1ZrloGtei07I=";
  };

  build-system = [ setuptools ];

  dependencies = [
    tqdm
  ];

  nativeCheckInputs = [
    pytest-asyncio
    pytestCheckHook
    ffmpeg
    procps
  ];

  enabledTestPaths = [ "test/test.py" ];

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

  meta = with lib; {
    description = "Run an ffmpeg command with progress";
    mainProgram = "ffmpeg-progress-yield";
    homepage = "https://github.com/slhck/ffmpeg-progress-yield";
    changelog = "https://github.com/slhck/ffmpeg-progress-yield/blob/v${version}/CHANGELOG.md";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ prusnak ];
  };
}
