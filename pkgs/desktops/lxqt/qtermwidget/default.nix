{ lib, mkDerivation, fetchFromGitHub, cmake, qtbase, qttools, lxqt-build-tools }:

mkDerivation rec {
  pname = "qtermwidget";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "1pz8dwb86jpga4vfyn5v9n2s6dx3zh74yfp1kjsmsmhf878zs6lv";
  };

  nativeBuildInputs = [ cmake lxqt-build-tools ];

  buildInputs = [ qtbase qttools ];

  meta = with lib; {
    description = "A terminal emulator widget for Qt 5";
    homepage = https://github.com/lxqt/qtermwidget;
    license = licenses.gpl2;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
