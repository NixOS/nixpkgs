{ lib
, buildPythonPackage
, fetchPypi
, colorama
, tqdm
, pytestCheckHook
, ffmpeg
, procps
}:

buildPythonPackage rec {
  pname = "ffmpeg-progress-yield";
  version = "0.7.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-wK33h+Qg737hSv+2HF4hvfBDDsJpI+7mGbRgUQvrZb0=";
  };

  propagatedBuildInputs = [ colorama tqdm ];

  nativeCheckInputs = [ pytestCheckHook ffmpeg procps ];

  disabledTests = [
    "test_quit"
    "test_quit_gracefully"
  ];

  pytestFlagsArray = [ "test/test.py" ];

  pythonImportsCheck = [ "ffmpeg_progress_yield" ];

  meta = with lib; {
    description = "Run an ffmpeg command with progress";
    homepage = "https://github.com/slhck/ffmpeg-progress-yield";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ prusnak ];
  };
}
