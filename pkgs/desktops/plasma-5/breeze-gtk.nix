{ mkDerivation, lib, extra-cmake-modules, gtk2, qtbase, }:

let inherit (lib) getLib; in

mkDerivation {
  name = "breeze-gtk";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [ qtbase ];
  postPatch = ''
    sed -i cmake/FindGTKEngine.cmake \
      -e "s|\''${KDE_INSTALL_FULL_LIBDIR}|${getLib gtk2}/lib|"
  '';
  cmakeFlags = [ "-DWITH_GTK3_VERSION=3.22" ];
}
