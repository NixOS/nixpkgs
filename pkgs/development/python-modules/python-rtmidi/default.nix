{ lib
, stdenv
<<<<<<< HEAD
, alabaster
, alsa-lib
, buildPythonPackage
, CoreAudio
, CoreMIDI
, CoreServices
, Foundation
, cython_3
, fetchPypi
, flake8
, libjack2
, meson-python
, ninja
, pkg-config
, pythonOlder
, tox
, wheel
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
}:

buildPythonPackage rec {
  pname = "python-rtmidi";
<<<<<<< HEAD
  version = "1.5.5";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "python_rtmidi";
    inherit version;
    hash = "sha256-Pz6bD6SX6BPMC91zsorgeXfJGAPk1VULx8ejShUBy94=";
  };

  nativeBuildInputs = [
    cython_3
    meson-python
    ninja
    pkg-config
    wheel
  ];

  buildInputs = [
  ] ++ lib.optionals stdenv.isLinux [
    libjack2
=======
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
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    alsa-lib
  ] ++ lib.optionals stdenv.isDarwin [
    CoreAudio
    CoreMIDI
    CoreServices
<<<<<<< HEAD
    Foundation
  ];

=======
  ];
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
  nativeCheckInputs = [
    tox
    flake8
    alabaster
  ];

<<<<<<< HEAD
  pythonImportsCheck = [
    "rtmidi"
  ];

  meta = with lib; {
    description = "A Python binding for the RtMidi C++ library implemented using Cython";
    homepage = "https://github.com/SpotlightKid/python-rtmidi";
    changelog = "https://github.com/SpotlightKid/python-rtmidi/blob/${version}/CHANGELOG.md";
=======
  meta = with lib; {
    description = "A Python binding for the RtMidi C++ library implemented using Cython";
    homepage = "https://github.com/SpotlightKid/python-rtmidi";
>>>>>>> 903308adb4b (Improved error handling, differentiate nix/non-nix networks)
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
