{
  lib,
  buildPythonPackage,
  fetchPypi,
  colorama,
  tqdm,
  pytestCheckHook,
  pythonOlder,
  ffmpeg,
  procps,
}:

buildPythonPackage rec {
  pname = "ffmpeg-progress-yield";
  version = "0.7.8";
  format = "setuptools";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-muauX4Mq58ew9lGPE0H+bu4bqPydNADLocujjy6qRh4=";
  };

  propagatedBuildInputs = [
    colorama
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
