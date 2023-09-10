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
  version = "1.14.0";

  src = fetchPypi {
    inherit pname version;
    hash = "sha256-FtIM5CIQtDTrBbpGns24KTrH7TwM4N1PcOMNctdgIic=";
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

  nativeCheckInputs = [
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
