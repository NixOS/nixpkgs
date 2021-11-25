{ mkDerivation, lib, extra-cmake-modules, gtk2, qtbase, sassc, python3, breeze-qt5 }:

let inherit (lib) getLib; in

mkDerivation {
  name = "breeze-gtk";
  nativeBuildInputs = [ extra-cmake-modules sassc python3 python3.pkgs.pycairo breeze-qt5 ];
  buildInputs = [ qtbase ];
  patches = [
    ./patches/0001-fix-add-executable-bit.patch
  ];
  postPatch = ''
    sed -i cmake/FindGTKEngine.cmake \
      -e "s|\''${KDE_INSTALL_FULL_LIBDIR}|${getLib gtk2}/lib|"
  '';
  cmakeFlags = [ "-DWITH_GTK3_VERSION=3.22" ];
}
