{ lib
, buildPythonPackage
, fetchPypi
, isPyPy
, pkgs
}:

buildPythonPackage rec {
  pname = "PyAudio";
  version = "0.2.11";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "93bfde30e0b64e63a46f2fd77e85c41fd51182a4a3413d9edfaf9ffaa26efb74";
  };

  buildInputs = [ pkgs.portaudio ];

  meta = with lib; {
    description = "Python bindings for PortAudio";
    homepage = "https://people.csail.mit.edu/hubert/pyaudio/";
    license = licenses.mit;
  };

}
