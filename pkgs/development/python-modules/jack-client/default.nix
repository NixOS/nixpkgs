{
  lib,
  buildPythonPackage,
  fetchFromGitHub,
  setuptools,
  cffi,
  numpy,
  pipewire,
}:

buildPythonPackage rec {
  pname = "jack-client";
  version = "0.5.5";

  src = fetchFromGitHub {
    owner = "spatialaudio";
    repo = "jackclient-python";
    rev = version;
    hash = "sha256-SqDHFUlAtGbT/UJALykPvdP7+5KUlZkMpwYDjq+rU98=";
  };

  pyproject = true;

  nativeBuildInputs = [
    setuptools
    cffi
  ];

  propagatedBuildInputs = [
    numpy
    cffi
    pipewire.jack
  ];

  # Patch in the absolute path to PipeWire's libjack shim directly so JACK calls are routed to PipeWire.
  postPatch = ''
    substituteInPlace src/jack.py \
      --replace "_libname = _find_library('jack')" "_libname = '${pipewire.jack}/lib/libjack.so'"
  '';

  meta = {
    description = "JACK Audio Connection Kit client for Python";
    homepage = "https://github.com/spatialaudio/jackclient-python";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ DimseBoms ];
    platforms = lib.platforms.linux;
  };
}
