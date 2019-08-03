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
  version = "1.11.0";

  src = fetchPypi {
    inherit pname version;
    sha256 = "132y3gc0dj9vmgajmzz2fyc3icrrgsvynwfl0g31bylm7h9p220x";
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
