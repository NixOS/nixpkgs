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
  version = "0.1.4";
  disabled = isPy27;

  src = fetchFromGitHub {
    owner = "spatialaudio";
    repo = "python-rtmixer";
    rev = "refs/tags/${version}";
    sha256 = "sha256-S8aVfxoG0o5GarDX5ZIDQ3GKOT32NtttQJ449FI9Fy0=";
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
