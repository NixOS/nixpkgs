{ lib, buildPythonPackage, fetchPypi, libpulseaudio, glibc, substituteAll, stdenv, pulseaudio, unittestCheckHook }:

buildPythonPackage rec {
  pname = "pulsectl";
  version = "22.3.2";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-zBdOHO69TmIixbePT0FfEugHU8mrdas1QVm0y1lQsIQ=";
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

  checkInputs = [ unittestCheckHook pulseaudio ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  meta = with lib; {
    description = "Python high-level interface and ctypes-based bindings for PulseAudio (libpulse)";
    homepage = "https://pypi.python.org/pypi/pulsectl/";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
