{ stdenv, buildPythonPackage, fetchPypi, scipy, ffmpeg-full }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "pydub";
  version = "0.20.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "0hqsvvph6ks4kxj0m2q1xvl5bllqmpk78rlqpqhh79schl344xkv";
  };

  patches = [
    ./pyaudioop-python3.patch
  ];

  checkInputs = [ scipy ffmpeg-full ];

  meta = with stdenv.lib; {
    description = "Manipulate audio with a simple and easy high level interface.";
    homepage    = "http://pydub.com/";
    license     = licenses.mit;
    platforms   = platforms.all;
  };
}
