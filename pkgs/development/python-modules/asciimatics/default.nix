{ lib
, buildPythonPackage
, fetchPypi
, setuptools_scm
, pyfiglet
, pillow
, wcwidth
, future
, mock
, nose
}:

buildPythonPackage rec {
  pname = "asciimatics";
  version = "1.12.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "4120461a3fb345638dee4fe0f8a3d3f9b6d2d2e003f95c5f914523f94463158d";
  };

  nativeBuildInputs = [
    setuptools_scm
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
