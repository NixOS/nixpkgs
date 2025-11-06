{
  lib,
  stdenv,
  alabaster,
  alsa-lib,
  buildPythonPackage,
  cython,
  fetchPypi,
  flake8,
  libjack2,
  meson-python,
  ninja,
  pkg-config,
  pythonOlder,
  tox,
  wheel,
}:

buildPythonPackage rec {
  pname = "python-rtmidi";
  version = "1.5.8";
  format = "pyproject";

  disabled = pythonOlder "3.8";

  src = fetchPypi {
    pname = "python_rtmidi";
    inherit version;
    hash = "sha256-f5reaLBorgkADstWKulSHaOiNDYa1USeg/xzRUTQBPo=";
  };

  nativeBuildInputs = [
    cython
    meson-python
    ninja
    pkg-config
    wheel
  ];

  buildInputs =
    [ ]
    ++ lib.optionals stdenv.hostPlatform.isLinux [
      libjack2
      alsa-lib
    ];

  nativeCheckInputs = [
    tox
    flake8
    alabaster
  ];

  pythonImportsCheck = [ "rtmidi" ];

  meta = with lib; {
    description = "Python binding for the RtMidi C++ library implemented using Cython";
    homepage = "https://github.com/SpotlightKid/python-rtmidi";
    changelog = "https://github.com/SpotlightKid/python-rtmidi/blob/${version}/CHANGELOG.md";
    license = licenses.mit;
    maintainers = [ ];
  };
}
