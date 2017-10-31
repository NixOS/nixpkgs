{
  mkDerivation,
  extra-cmake-modules, kdoctools,
  kcmutils, kcrash, kdeclarative, kdelibs4support, kglobalaccel, kidletime,
  kwayland, libXcursor, pam, plasma-framework, qtdeclarative, qtx11extras,
  wayland,
}:

mkDerivation {
  name = "kscreenlocker";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kcmutils kcrash kdeclarative kdelibs4support kglobalaccel kidletime kwayland
    libXcursor pam plasma-framework qtdeclarative qtx11extras wayland
  ];
  outputs = [ "out" "dev" ];
}
