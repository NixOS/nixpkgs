{ lib, buildPythonPackage, fetchPypi, libpulseaudio, glibc, substituteAll, stdenv, pulseaudio, python }:

buildPythonPackage rec {
  pname = "pulsectl";
  version = "20.5.1";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1nr2xq4as74vz9xhsgw0qg4hmc3q5y13ia16v1l68zaajzks1c1r";
  };

  patches = [
    (substituteAll {
      src = ./library-paths.patch;
      libpulse = "${libpulseaudio.out}/lib/libpulse${stdenv.hostPlatform.extensions.sharedLibrary}";
      librt = "${glibc.out}/lib/librt${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  checkInputs = [ pulseaudio ];
  checkPhase = ''
    ${python.interpreter} -m unittest pulsectl.tests.all
  '';

  meta = with lib; {
    description = "Python high-level interface and ctypes-based bindings for PulseAudio (libpulse)";
    homepage = "https://pypi.python.org/pypi/pulsectl/";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
