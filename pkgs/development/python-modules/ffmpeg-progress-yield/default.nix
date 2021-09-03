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
  version = "0.0.4";

  src = fetchPypi {
    inherit pname version;
    sha256 = "e944093e2c1b213da8fa4f0c276c1bad44e0b8ba8be7e4fd001f5132d16baef5";
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
