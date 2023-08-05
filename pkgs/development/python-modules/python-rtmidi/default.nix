{ lib
, stdenv
, buildPythonPackage
, fetchPypi
, pythonOlder
, pythonAtLeast
, pkg-config
, alsa-lib
, libjack2
, tox
, flake8
, alabaster
, CoreAudio
, CoreMIDI
, CoreServices
}:

buildPythonPackage rec {
  pname = "python-rtmidi";
  version = "1.4.9";

  # https://github.com/SpotlightKid/python-rtmidi/issues/115
  disabled = pythonOlder "3.6" || pythonAtLeast "3.11";

  src = fetchPypi {
    inherit pname version;
    sha256 = "bfeb4ed99d0cccf6fa2837566907652ded7adc1c03b69f2160c9de4082301302";
  };

  nativeBuildInputs = [ pkg-config ];
  buildInputs = [
    libjack2
  ] ++ lib.optionals stdenv.isLinux [
    alsa-lib
  ] ++ lib.optionals stdenv.isDarwin [
    CoreAudio
    CoreMIDI
    CoreServices
  ];
  nativeCheckInputs = [
    tox
    flake8
    alabaster
  ];

  meta = with lib; {
    description = "A Python binding for the RtMidi C++ library implemented using Cython";
    homepage = "https://github.com/SpotlightKid/python-rtmidi";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
