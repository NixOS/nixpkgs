{ stdenv
, buildPythonPackage
, fetchPypi
, isPyPy
, pkgs
}:

buildPythonPackage rec {
  pname = "python-pyaudio";
  version = "0.2.9";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "bfd694272b3d1efc51726d0c27650b3c3ba1345f7f8fdada7e86c9751ce0f2a1";
  };

  buildInputs = [ pkgs.portaudio ];

  meta = with stdenv.lib; {
    description = "Python bindings for PortAudio";
    homepage = "http://people.csail.mit.edu/hubert/pyaudio/";
    license = licenses.mit;
  };

}
