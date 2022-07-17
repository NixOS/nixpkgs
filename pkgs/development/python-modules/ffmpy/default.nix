{ lib
, buildPythonPackage
, fetchPypi
, pythonOlder
, ffmpeg
}:

buildPythonPackage rec {
  pname = "ffmpy";
  version = "0.3.0";

  disabled = pythonOlder "3.6";

  # The github repo has no release tags, the pypi distribution has no tests.
  # This package is quite trivial anyway, and the tests mainly play around with the ffmpeg cli interface.
  # https://github.com/Ch00k/ffmpy/issues/60
  src = fetchPypi {
    inherit pname version;
    sha256 = "dXWRWB7uJbSlCsn/ubWANaJ5RTPbR+BRL1P7LXtvmtw=";
  };

  propagatedBuildInputs = [
    ffmpeg
  ];

  pythonImportsCheck = [ "ffmpy" ];

  meta = with lib; {
    description = "A simple python interface for FFmpeg/FFprobe";
    homepage = "https://github.com/Ch00k/ffmpy";
    license = licenses.mit;
    maintainers = with maintainers; [ pbsds ];
  };
}
