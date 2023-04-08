{ mkDerivation
, extra-cmake-modules
, flatpak
, kcmutils
, kconfig
, kdeclarative
}:

mkDerivation {
  pname = "flatpak-kcm";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    flatpak
    kcmutils
    kconfig
    kdeclarative
  ];
}
