{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, substituteAll
, portmidi
, pygame
, python-rtmidi
, rtmidi-python
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "mido";
  version = "1.2.9";

  src = fetchPypi {
    inherit pname version;
    sha256 = "1k3sgkxc7j49bapib3b5jnircb1yhyyd8mi0mbfd78zgix9db9y4";
  };

  patches = [
    (substituteAll {
      src = ./libportmidi-cdll.patch;
      libportmidi = "${portmidi.out}/lib/libportmidi${stdenv.targetPlatform.extensions.sharedLibrary}";
    })
  ];

  propagatedBuildInputs = [
    pygame
    python-rtmidi
    rtmidi-python
  ];

  checkInputs = [
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
