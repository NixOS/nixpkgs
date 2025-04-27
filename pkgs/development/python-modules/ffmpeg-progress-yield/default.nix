{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  tqdm,
  pytestCheckHook,
  pythonOlder,
  ffmpeg,
  procps,
}:

buildPythonPackage rec {
  pname = "ffmpeg-progress-yield";
  version = "0.11.3";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchFromGitHub {
    owner = "slhck";
    repo = "ffmpeg-progress-yield";
    tag = "v${version}";
    hash = "sha256-o5PlL6Ggo0Mrs/ujdnTV5GMAVeG2wpBoBDfxTVic3mA=";
  };

  build-system = [ setuptools ];

  dependencies = [
    tqdm
  ];

  nativeCheckInputs = [
    pytestCheckHook
    ffmpeg
    procps
  ];

  disabledTests = [
    "test_quit"
    "test_quit_gracefully"
  ];

  pytestFlagsArray = [ "test/test.py" ];

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
