{
  fetchFromGitHub,
  buildPythonPackage,
  isPy27,
  setuptools,
  cython,
  portaudio,
  cffi,
  pa-ringbuffer,
  sounddevice,
  lib,
}:

buildPythonPackage rec {
  pname = "rtmixer";
  version = "0.1.7";
  pyproject = true;
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "spatialaudio";
    repo = "python-rtmixer";
    rev = "refs/tags/${version}";
    hash = "sha256-K5w6XWnDdA5HrzDOMhqinlxrg/09AF6c5CWZEsfVHb4=";
    fetchSubmodules = true;
  };

  build-system = [ setuptools ];

  buildInputs = [ portaudio ];

  nativeBuildInputs = [
    cython
    cffi
  ];

  dependencies = [
    cffi
    pa-ringbuffer
    sounddevice
  ];

  meta = {
    description = "Reliable low-latency audio playback and recording with Python, using PortAudio via the sounddevice module";
    homepage = "https://python-rtmixer.readthedocs.io";
    maintainers = with lib.maintainers; [ laikq ];
    license = lib.licenses.mit;
  };
}
