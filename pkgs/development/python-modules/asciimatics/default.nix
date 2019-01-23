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
  version = "1.10.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "9101b0b6885542f324980bbe13a772475cd6a12678f601228eaaea412db919ab";
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

  meta = with lib; {
    description = "Helps to create full-screen text UIs (from interactive forms to ASCII animations) on any platform";
    homepage = https://github.com/peterbrittain/asciimatics;
    license = licenses.asl20;
    maintainers = with maintainers; [ cmcdragonkai ];
  };
}
