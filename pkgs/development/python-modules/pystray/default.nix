{ lib, buildPythonPackage, fetchFromGitHub
, pillow, xlib, six, xvfb-run, sphinx }:

buildPythonPackage rec {
  pname = "pystray";
  version = "0.19.1";

  src = fetchFromGitHub {
    owner = "moses-palmer";
    repo = "pystray";
    rev = "v${version}";
    sha256 = "sha256-7w3odneRfDQ7K965ffJ+xSaGvg/KM0vTrSIj0ee13Uk=";
  };

  nativeBuildInputs = [ sphinx ];
  propagatedBuildInputs = [ pillow xlib six ];
  checkInputs = [ xvfb-run ];

  checkPhase = ''
    rm tests/icon_tests.py # test needs user input

    xvfb-run -s '-screen 0 800x600x24' python setup.py test
  '';

  meta = with lib; {
    homepage = "https://github.com/moses-palmer/pystray";
    description = "This library allows you to create a system tray icon";
    license = with licenses; [ gpl3Plus lgpl3Plus ];
    platforms = platforms.linux;
    maintainers = with maintainers; [ jojosch ];
  };
}
