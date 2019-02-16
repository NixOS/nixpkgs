{ stdenv, fetchFromGitHub, cmake, qtbase, qttools, lxqt-build-tools }:

stdenv.mkDerivation rec {
  pname = "qtermwidget";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "lxqt";
    repo = pname;
    rev = version;
    sha256 = "0wv8fssbc2w7kkpq9ngsa8wyjraggdhsbz36gyxyv8fy5m78jq0n";
  };

  nativeBuildInputs = [ cmake lxqt-build-tools ];

  buildInputs = [ qtbase qttools];

  meta = with stdenv.lib; {
    description = "A terminal emulator widget for Qt 5";
    homepage = https://github.com/lxqt/qtermwidget;
    license = licenses.gpl2;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
