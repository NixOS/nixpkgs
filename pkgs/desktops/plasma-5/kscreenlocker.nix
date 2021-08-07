{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kcmutils, kcrash, kdeclarative, kglobalaccel, kidletime,
  kwayland, libXcursor, pam, plasma-framework, qtbase, qtdeclarative, qtx11extras,
  wayland, layer-shell-qt,
}:

mkDerivation {
  name = "kscreenlocker";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kcmutils kcrash kdeclarative kglobalaccel kidletime kwayland
    libXcursor pam plasma-framework qtdeclarative qtx11extras wayland
    layer-shell-qt
  ];
  outputs = [ "out" "dev" ];
}
