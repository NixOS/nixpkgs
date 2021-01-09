{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kcmutils, kcrash, kdeclarative, kdelibs4support, kglobalaccel, kidletime,
  kwayland, libXcursor, pam, plasma-framework, qtbase, qtdeclarative, qtx11extras,
  wayland,
}:

mkDerivation {
  name = "kscreenlocker";
  meta.broken = lib.versionOlder qtbase.version "5.15.0";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kcmutils kcrash kdeclarative kdelibs4support kglobalaccel kidletime kwayland
    libXcursor pam plasma-framework qtdeclarative qtx11extras wayland
  ];
  outputs = [ "out" "dev" ];
}
