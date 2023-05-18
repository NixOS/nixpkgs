{ lib, buildPythonPackage, fetchPypi, libpulseaudio, glibc, substituteAll, stdenv, pulseaudio, unittestCheckHook }:

buildPythonPackage rec {
  pname = "pulsectl";
  version = "23.5.1";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-jvwmDtchLuT55QqLhWyEkRJl9OrELMbALHs3yFGig0s=";
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

  nativeCheckInputs = [ unittestCheckHook pulseaudio ];

  preCheck = ''
    export HOME=$TMPDIR
  '';

  meta = with lib; {
    description = "Python high-level interface and ctypes-based bindings for PulseAudio (libpulse)";
    homepage = "https://github.com/mk-fg/python-pulse-control";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
