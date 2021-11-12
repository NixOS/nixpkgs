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
  version = "0.1.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "92ae36ff5cf38428bd3695629b5065d161c658fb0de0faf2c20cd7a99dac3820";
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
