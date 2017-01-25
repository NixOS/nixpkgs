{ stdenv, fetchFromGitHub, cmake, pkgconfig, qt5, kde5, lxqt,
xdg-user-dirs, libpulseaudio }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "pavucontrol-qt";
  version = "0.1.0";

  srcs = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "1bis88ykasrnk9a55nnbn832acjz2h76h6i3lbxnb36yq71wan7j";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    qt5.qtbase
    qt5.qttools
    qt5.qtx11extras
    qt5.qtsvg
    kde5.kwindowsystem
    lxqt.liblxqt
    lxqt.libqtxdg
    xdg-user-dirs
    libpulseaudio
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  meta = with stdenv.lib; {
    description = "A Pulseaudio mixer in Qt (port of pavucontrol)";
    homepage = https://github.com/lxde/pavucontrol-qt;
    license = licenses.gpl2;
    maintainers = with maintainers; [ romildo ];
    platforms = with platforms; unix;
  };
}
