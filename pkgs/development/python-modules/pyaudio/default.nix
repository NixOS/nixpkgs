{
  lib,
  buildPythonPackage,
  fetchPypi,
  isPyPy,
  pkgs,
}:

buildPythonPackage (finalAttrs: {
  pname = "pyaudio";
  version = "0.2.14";
  format = "setuptools";
  disabled = isPyPy;

  src = fetchPypi {
    pname = "PyAudio";
    inherit (finalAttrs) version;
    hash = "sha256-eN//OHm0mU0fT8ZIVkald1XG7jwZZHpJH3kKCJW9L4c=";
  };

  buildInputs = [ pkgs.portaudio ];

  meta = {
    description = "Python bindings for PortAudio";
    homepage = "https://people.csail.mit.edu/hubert/pyaudio/";
    license = lib.licenses.mit;
  };
})
