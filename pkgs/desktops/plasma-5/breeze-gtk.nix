{ mkDerivation , extra-cmake-modules , qtbase }:

mkDerivation {
  name = "breeze-gtk";
  nativeBuildInputs = [ extra-cmake-modules ];
  cmakeFlags = [ "-DWITH_GTK3_VERSION=3.20" ];
  buildInputs = [ qtbase ];
}
