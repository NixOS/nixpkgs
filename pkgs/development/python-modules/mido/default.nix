{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, substituteAll
, portmidi
, python-rtmidi
, pytestCheckHook
, setuptools
, setuptools-scm
}:

buildPythonPackage rec {
  pname = "mido";
  version = "1.3.2";
  format = "pyproject";

  src = fetchPypi {
    inherit pname version;
    sha256 = "sha256-Ouootu1zD3N9WxLaNXjevp3FAFj6Nw/pzt7ZGJtnw0g=";
  };

  patches = [
    (substituteAll {
      src = ./libportmidi-cdll.patch;
      libportmidi = "${portmidi.out}/lib/libportmidi${stdenv.hostPlatform.extensions.sharedLibrary}";
    })
  ];

  nativeBuildInputs = [
    setuptools
    setuptools-scm
  ];

  propagatedBuildInputs = [
    python-rtmidi
  ];

  nativeCheckInputs = [
    pytestCheckHook
  ];

  pythonImportsCheck = [
    "mido"
  ];

  meta = with lib; {
    description = "MIDI Objects for Python";
    homepage = "https://mido.readthedocs.io";
    license = licenses.mit;
    maintainers = with maintainers; [ ];
  };
}
