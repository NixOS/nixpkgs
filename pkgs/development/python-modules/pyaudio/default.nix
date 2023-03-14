{ lib
, buildPythonPackage
, fetchPypi
, isPyPy
, pkgs
}:

buildPythonPackage rec {
  pname = "PyAudio";
  version = "0.2.13";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-JrzMgeQkPRwP9Uh+a0gd5jKfzWXHk2XCZ87zjzY6K1Y=";
  };

  buildInputs = [ pkgs.portaudio ];

  meta = with lib; {
    description = "Python bindings for PortAudio";
    homepage = "https://people.csail.mit.edu/hubert/pyaudio/";
    license = licenses.mit;
  };

}
