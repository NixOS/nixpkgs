{ lib
, stdenv
, alabaster
, alsa-lib
, buildPythonPackage
, CoreAudio
, CoreMIDI
, CoreServices
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
}:

buildPythonPackage rec {
  pname = "python-rtmidi";
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

  pythonImportsCheck = [
    "rtmidi"
  ];

  meta = with lib; {
    description = "A Python binding for the RtMidi C++ library implemented using Cython";
    homepage = "https://github.com/SpotlightKid/python-rtmidi";
    changelog = "https://github.com/SpotlightKid/python-rtmidi/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = with maintainers; [ hexa ];
  };
}
