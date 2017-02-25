{
  stdenv, lib, src, version,
  automoc4, cmake, perl, pkgconfig,
  kdelibs4, qt4, xproto
}:

stdenv.mkDerivation {
  name = "breeze-qt4-${version}";
  meta = {
    license = with lib.licenses; [
      lgpl21Plus lgpl3Plus bsd2 mit gpl2Plus gpl3Plus fdl12
    ];
    platforms = lib.platforms.linux;
    maintainers = with lib.maintainers; [ ttuegel ];
    homepage = "http://www.kde.org";
  };
  inherit src;
  buildInputs = [ kdelibs4 qt4 xproto ];
  nativeBuildInputs = [ automoc4 cmake perl pkgconfig ];
  cmakeFlags = [
    "-DUSE_KDE4=ON"
    "-DQT_QMAKE_EXECUTABLE=${qt4}/bin/qmake"
  ];
}
