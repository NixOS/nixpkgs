{
  stdenv,
  lib,
  buildPythonPackage,
  fetchPypi,
  substituteAll,

  # build-system
  setuptools,
  setuptools-scm,

  # dependencies
  packaging,

  # native dependencies
  portmidi,

  # optional-dependencies
  pygame,
  python-rtmidi,
  rtmidi-python,

  # tests
  pytestCheckHook,
  pythonOlder,

}:

buildPythonPackage rec {
  pname = "mido";
  version = "1.3.2";
  pyproject = true;

  disabled = pythonOlder "3.7";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-Ouootu1zD3N9WxLaNXjevp3FAFj6Nw/pzt7ZGJtnw0g=";
  };

  patches = [
    (substituteAll {
      src = ./libportmidi-cdll.patch;
      libportmidi = "${portmidi.out}/lib/libportmidi${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  build-system = [
    setuptools
    setuptools-scm
  ];

  pythonRelaxDeps = [ "packaging" ];

  dependencies = [ packaging ];

  optional-dependencies = {
    ports-pygame = [ pygame ];
    ports-rtmidi = [ python-rtmidi ];
    ports-rtmidi-python = [ rtmidi-python ];
  };

  nativeCheckInputs = [ pytestCheckHook ];

  pythonImportsCheck = [ "mido" ];

  meta = with lib; {
    description = "MIDI Objects for Python";
    homepage = "https://mido.readthedocs.io";
    changelog = "https://github.com/mido/mido/releases/tag/${version}";
    license = licenses.mit;
    maintainers = [ ];
  };
}
