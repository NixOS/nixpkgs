{ lib, buildPythonPackage, fetchFromGitHub
, pillow, xlib, six, xvfb_run, sphinx }:

buildPythonPackage rec {
  pname = "pystray";
  version = "0.17.2";

  src = fetchFromGitHub {
    owner = "moses-palmer";
    repo = "pystray";
    rev = "v${version}";
    sha256 = "sha256-/dU+jwe/3qhypq7e5tawhJKzSryW7EIbmrpP+VLDvHA=";
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
    platforms = platforms.linux;
    maintainers = with maintainers; [ jojosch ];
  };
}
