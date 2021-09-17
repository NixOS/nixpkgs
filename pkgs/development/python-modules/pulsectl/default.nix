{ lib, buildPythonPackage, fetchPypi, libpulseaudio, glibc, substituteAll, stdenv, pulseaudio, python }:

buildPythonPackage rec {
  pname = "pulsectl";
  version = "21.9.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "8eef4dbfc97d984e63fd609a3f690d005173ec5342be88d10f67dd507affdf32";
  };

  patches = [
    # substitute library paths for libpulse and librt
    (substituteAll {
      src = ./library-paths.patch;
      libpulse = "${libpulseaudio.out}/lib/libpulse${stdenv.hostPlatform.extensions.sharedLibrary}";
      librt = "${glibc.out}/lib/librt${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  pythonImportsCheck = [
    "pulsectl"
  ];

  checkInputs = [ pulseaudio ];

  checkPhase = ''
    export HOME=$TMPDIR
    ${python.interpreter} -m unittest discover
  '';

  meta = with lib; {
    description = "Python high-level interface and ctypes-based bindings for PulseAudio (libpulse)";
    homepage = "https://pypi.python.org/pypi/pulsectl/";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
