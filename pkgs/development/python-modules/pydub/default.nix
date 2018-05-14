{ stdenv, buildPythonPackage, fetchPypi, scipy, ffmpeg-full }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "pydub";
  version = "0.21.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "27acc5977b0f5220682175d44fda737bbf818143b0832c0c3863b5dde38e197a";
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
