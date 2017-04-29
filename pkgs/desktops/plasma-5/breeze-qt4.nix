{
  plasmaPackage, lib,
  automoc4, cmake, perl, pkgconfig,
  kdelibs4, qt4, xproto
}:

plasmaPackage {
  name = "breeze-qt4";
  sname = "breeze";
  buildInputs = [ kdelibs4 qt4 xproto ];
  nativeBuildInputs = [ automoc4 cmake perl pkgconfig ];
  cmakeFlags = [
    "-DUSE_KDE4=ON"
    "-DQT_QMAKE_EXECUTABLE=${qt4}/bin/qmake"
  ];
}
