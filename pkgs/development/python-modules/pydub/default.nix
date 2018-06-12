{ stdenv, buildPythonPackage, fetchPypi, scipy, ffmpeg-full }:

buildPythonPackage rec {
  name = "${pname}-${version}";
  pname = "pydub";
  version = "0.22.0";
  src = fetchPypi {
    inherit pname version;
    sha256 = "91192b94a28121cccd64bfaef1d12da59f3a69a5f4c35f67d428bfc395f390b5";
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
