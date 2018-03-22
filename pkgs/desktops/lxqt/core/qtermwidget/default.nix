{ stdenv, fetchFromGitHub, cmake, qt5, lxqt }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "qtermwidget";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "14yjz6b1l2yd7sfsxjv26yg5153fpyq23443kswkgkd9jh32gxj4";
  };

  nativeBuildInputs = [ cmake lxqt.lxqt-build-tools ];

  buildInputs = [ qt5.qtbase qt5.qttools];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  meta = with stdenv.lib; {
    description = "A terminal emulator widget for Qt 5";
    homepage = https://github.com/lxde/qtermwidget;
    license = licenses.gpl2;
    platforms = with platforms; unix;
    maintainers = with maintainers; [ romildo ];
  };
}
