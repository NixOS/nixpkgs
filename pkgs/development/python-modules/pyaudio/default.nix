{ stdenv, buildPythonPackage, fetchPypi, isPyPy
, portaudio }:

buildPythonPackage rec {
  pname = "PyAudio";
  version = "0.2.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bfd694272b3d1efc51726d0c27650b3c3ba1345f7f8fdada7e86c9751ce0f2a1";
  };

  disabled = isPyPy;

  buildInputs = [ portaudio ];

  meta = with stdenv.lib; {
    description = "Python bindings for PortAudio";
    homepage = https://people.csail.mit.edu/hubert/pyaudio/;
    license = licenses.mit;
  };
}
