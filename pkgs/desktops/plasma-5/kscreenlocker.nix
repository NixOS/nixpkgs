{
  mkDerivation, lib,
  extra-cmake-modules, kdoctools,
  kcmutils, kcrash, kdeclarative, kglobalaccel, kidletime,
  kwayland, libXcursor, pam, plasma-framework, qtbase, qtdeclarative, qtx11extras,
  wayland,
}:

mkDerivation {
  name = "kscreenlocker";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kcmutils kcrash kdeclarative kglobalaccel kidletime kwayland
    libXcursor pam plasma-framework qtdeclarative qtx11extras wayland
  ];
  outputs = [ "out" "dev" ];
}
