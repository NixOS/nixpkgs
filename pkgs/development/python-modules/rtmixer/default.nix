{ fetchFromGitHub
, buildPythonPackage
, isPy27
, cython
, portaudio
, cffi
, pa-ringbuffer
, sounddevice
, lib
}:

buildPythonPackage rec {
  pname = "rtmixer";
  version = "0.1.1";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "spatialaudio";
    repo = "python-rtmixer";
    rev = version;
    sha256 = "1bvgzzxiypvvb3qacbcry6761x9sk3dnx7jga7pli63f69vakg4y";
    fetchSubmodules = true;
  };

  buildInputs = [ portaudio ];
  nativeBuildInputs = [ cython ];

  propagatedBuildInputs = [
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
