{ stdenv, fetchFromGitHub, cmake, pkgconfig, qt5, kde5, lxqt, xorg,
libfm, menu-cache }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "libfm-qt";
  version = "0.11.1";

  src = fetchFromGitHub {
    owner = "lxde";
    repo = pname;
    rev = version;
    sha256 = "1kgvzjsa4ihlj2clz6y6s95nq0lhg66d1dhkgw3mdqaak7d0pdiz";
  };

  nativeBuildInputs = [
    cmake
    pkgconfig
    lxqt.liblxqt
    lxqt.libqtxdg
  ];

  buildInputs = [
    qt5.qtx11extras
    qt5.qttools
    qt5.qtsvg
    kde5.kwindowsystem
    xorg.libpthreadstubs
    xorg.libXdmcp
    libfm
    menu-cache
  ];

  cmakeFlags = [ "-DPULL_TRANSLATIONS=NO" ];
   
  meta = with stdenv.lib; {
    description = "Core library of PCManFM-Qt (Qt binding for libfm)";
    homepage = https://github.com/lxde/libfm-qt;
    license = licenses.lgpl21;
    maintainers = with maintainers; [ romildo ];
    platforms = with platforms; unix;
  };
}
