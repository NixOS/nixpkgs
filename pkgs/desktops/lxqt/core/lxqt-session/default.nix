{ stdenv, fetchFromGitHub, cmake, pkgconfig, qt5, kde5, lxqt, xorg, xdg-user-dirs }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "lxqt-session";
  version = "0.11.0";

  srcs = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "1vb8mcy6z1irnd977x5425mbp4c7yc9dhk5552isqss1qb44hpn4";
  };

  nativeBuildInputs = [ cmake pkgconfig ];

  buildInputs = [
    qt5.qtbase
    qt5.qttools
    qt5.qtsvg
    kde5.kwindowsystem
    lxqt.liblxqt
    lxqt.libqtxdg
    xorg.libpthreadstubs
    xorg.libXdmcp
    xdg-user-dirs
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];

  meta = with stdenv.lib; {
    description = "An alternative session manager ported from the original razor-session";
    homepage = https://github.com/lxde/lxqt-session;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ romildo ];
    platforms = with platforms; unix;
  };
}
