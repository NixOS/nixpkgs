{ lib
, stdenv
, alabaster
, alsa-lib
, buildPythonPackage
, CoreAudio
, CoreMIDI
, CoreServices
, fetchPypi
, flake8
, libjack2
, meson-python
, pkg-config
, pythonOlder
, setuptools
, tox
}:

buildPythonPackage rec {
  pname = "python-rtmidi";
  version = "1.5.4";
  format = "pyproject";

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    pname = "python_rtmidi";
    inherit version;
    hash = "sha256-sLUGQoDba3iiYvqUFwMbIktSdZBb0OLhccfQ++FFRP0=";
  };

  nativeBuildInputs = [
    meson-python
    pkg-config
    setuptools
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
