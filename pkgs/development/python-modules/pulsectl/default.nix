{
  lib,
  buildPythonPackage,
  fetchPypi,
  libpulseaudio,
  glibc,
  replaceVars,
  stdenv,
  pulseaudio,
  unittestCheckHook,
}:

buildPythonPackage rec {
  pname = "pulsectl";
  version = "24.12.0";
  format = "setuptools";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-KI1nFSMqxvPc2xI/vsqiwLmlDqQIfm6Hw/hBqwqKB/w=";
  };

  patches = [
    # substitute library paths for libpulse and librt
    (replaceVars ./library-paths.patch {
      libpulse = "${libpulseaudio.out}/lib/libpulse${stdenv.hostPlatform.extensions.sharedLibrary}";
      librt = "${glibc.out}/lib/librt${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  pythonImportsCheck = [ "pulsectl" ];

  nativeCheckInputs = [
    unittestCheckHook
    pulseaudio
  ];

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
