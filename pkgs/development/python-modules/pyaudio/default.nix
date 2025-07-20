{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPyPy,
  pkgs,
}:

buildPythonPackage rec {
  pname = "pyaudio";
  version = "0.2.14";
  format = "setuptools";
  disabled = isPyPy;

  src = fetchPypi {
    pname = "PyAudio";
    inherit version;
    hash = "sha256-eN//OHm0mU0fT8ZIVkald1XG7jwZZHpJH3kKCJW9L4c=";
  };

  buildInputs = [ pkgs.portaudio ];

  meta = with lib; {
    description = "Python bindings for PortAudio";
    homepage = "https://people.csail.mit.edu/hubert/pyaudio/";
    license = licenses.mit;
  };
}
