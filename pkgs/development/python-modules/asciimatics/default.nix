{ lib
, buildPythonPackage
, fetchPypi
, setuptools-scm
, pyfiglet
, pillow
, wcwidth
, future
, mock
, nose
}:

buildPythonPackage rec {
  pname = "asciimatics";
  version = "1.13.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "a041826ec5add03fb882d8981c1debf9b9e98274f4f2d52ec21ef30de70c2c6e";
  };

  nativeBuildInputs = [
    setuptools-scm
  ];

  propagatedBuildInputs = [
    pyfiglet
    pillow
    wcwidth
    future
  ];

  checkInputs = [
    mock
    nose
  ];

  # tests require a pty emulator
  # which is too complicated to setup here
  doCheck = false;

  pythonImportsCheck =  [
    "asciimatics.effects"
    "asciimatics.renderers"
    "asciimatics.scene"
    "asciimatics.screen"
  ];

  meta = with lib; {
    description = "Helps to create full-screen text UIs (from interactive forms to ASCII animations) on any platform";
    homepage = "https://github.com/peterbrittain/asciimatics";
    license = licenses.asl20;
    maintainers = with maintainers; [ cmcdragonkai ];
  };
}
