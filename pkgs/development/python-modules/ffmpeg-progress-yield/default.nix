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
  version = "0.6.1";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-JLwvJcYcSe5Z7In34pQqHptd8TCrXJeJ6zPiGGv4T14=";
  };

  propagatedBuildInputs = [ colorama tqdm ];

  checkInputs = [ pytestCheckHook ffmpeg procps ];

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
