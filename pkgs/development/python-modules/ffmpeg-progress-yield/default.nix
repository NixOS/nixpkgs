{
  lib,
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
  format = "setuptools";

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
