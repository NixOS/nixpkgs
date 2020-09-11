{ lib, buildPythonPackage, fetchFromGitHub
, pillow, xlib, six, xvfb_run, sphinx }:

buildPythonPackage rec {
  pname = "pystray";
  version = "0.16.0";

  src = fetchFromGitHub {
    owner = "moses-palmer";
    repo = "pystray";
    rev = "v${version}";
    sha256 = "0q5yqfm5mzffx9vnp9xcnclgjzgs0b7f50i9xmxn1m1iha1zawh1";
  };

  propagatedBuildInputs = [ pillow xlib six ];
  nativeBuildInputs = [ sphinx ];
  checkInputs = [ xvfb_run ];

  checkPhase = ''
    rm tests/icon_tests.py # test needs user input

    xvfb-run -s '-screen 0 800x600x24' python setup.py test
  '';

  meta = with lib; {
    homepage = "https://github.com/moses-palmer/pystray";
    description = "This library allows you to create a system tray icon";
    license = licenses.lgpl3;
    maintainers = with maintainers; [ jojosch ];
  };
}
