{ stdenv
, lib
, buildPythonPackage
, fetchPypi
, substituteAll
, portmidi
, python-rtmidi
, pytestCheckHook
}:

buildPythonPackage rec {
  pname = "mido";
  version = "1.2.10";

  src = fetchPypi {
    inherit pname version;
    sha256 = "17b38a8e4594497b850ec6e78b848eac3661706bfc49d484a36d91335a373499";
  };

  patches = [
    (substituteAll {
      src = ./libportmidi-cdll.patch;
      libportmidi = "${portmidi.out}/lib/libportmidi${stdenv.targetPlatform.extensions.sharedLibrary}";
    })
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
