{ stdenv, buildPythonPackage, fetchPypi, scipy, ffmpeg-full }:

buildPythonPackage rec {
  pname = "pydub";
  version = "0.22.1";
  src = fetchPypi {
    inherit pname version;
    sha256 = "20beff39e9959a3b2cb4392802aecb9b2417837fff635d2b00b5ef5f5326d313";
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
