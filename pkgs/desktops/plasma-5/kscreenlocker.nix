{ mkDerivation
, extra-cmake-modules
, kdoctools
, wayland-scanner
, kcmutils
, kcrash
, kdeclarative
, kglobalaccel
, kidletime
, libkscreen
, kwayland
, libXcursor
, pam
, plasma-framework
, qtdeclarative
, qtx11extras
, wayland
, layer-shell-qt
}:

mkDerivation {
  pname = "kscreenlocker";
  nativeBuildInputs = [ extra-cmake-modules kdoctools wayland-scanner ];
  buildInputs = [
    kcmutils
    kcrash
    kdeclarative
    kglobalaccel
    kidletime
    libkscreen
    kwayland
    libXcursor
    pam
    plasma-framework
    qtdeclarative
    qtx11extras
    wayland
    layer-shell-qt
  ];
  outputs = [ "out" "dev" ];
}
