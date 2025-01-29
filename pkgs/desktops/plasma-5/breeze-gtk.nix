{ mkDerivation, extra-cmake-modules, qtbase, sassc, python3, breeze-qt5 }:

mkDerivation {
  pname = "breeze-gtk";
  nativeBuildInputs = [ extra-cmake-modules sassc python3 python3.pkgs.pycairo breeze-qt5 ];
  buildInputs = [ qtbase ];
  patches = [
    ./patches/0001-fix-add-executable-bit.patch
  ];
  cmakeFlags = [ "-DWITH_GTK3_VERSION=3.22" ];
}
