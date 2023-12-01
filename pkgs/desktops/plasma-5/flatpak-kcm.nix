{ mkDerivation
, extra-cmake-modules
, flatpak
, kcmutils
, kconfig
, kdeclarative
, kitemmodels
}:

mkDerivation {
  pname = "flatpak-kcm";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    flatpak
    kcmutils
    kconfig
    kdeclarative
    kitemmodels
  ];
}
