{ lib
, buildPythonPackage
, fetchPypi
, isPyPy
, pkgs
}:

buildPythonPackage rec {
  pname = "PyAudio";
  version = "0.2.12";
  disabled = isPyPy;

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Vd3123K8U3u6X128o6ufAiLuW4Qr2oOXjqsLe49g+54=";
  };

  buildInputs = [ pkgs.portaudio ];

  meta = with lib; {
    description = "Python bindings for PortAudio";
    homepage = "https://people.csail.mit.edu/hubert/pyaudio/";
    license = licenses.mit;
  };

}
