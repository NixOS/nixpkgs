{ lib
, buildPythonPackage
, fetchPypi
, colorama
, tqdm
, pytestCheckHook
, ffmpeg
}:

buildPythonPackage rec {
  pname = "ffmpeg-progress-yield";
  version = "0.2.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "26696726cc70c019d1b76bb25e4823c93f0837ddc86bc4ea26c08165270b4d92";
  };

  propagatedBuildInputs = [ colorama tqdm ];

  checkInputs = [ pytestCheckHook ffmpeg ];

  pytestFlagsArray = [ "test/test.py" ];

  pythonImportsCheck = [ "ffmpeg_progress_yield" ];

  meta = with lib; {
    description = "Run an ffmpeg command with progress";
    homepage = "https://github.com/slhck/ffmpeg-progress-yield";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ prusnak ];
  };
}
