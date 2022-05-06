{
  mkDerivation,
  extra-cmake-modules,
  breeze-qt5, kconfig, kconfigwidgets, kiconthemes, kio, knotifications,
  kwayland, libXcursor, qtquickcontrols2
}:

# TODO: install Noto Sans and Oxygen Mono fonts with plasma-integration

mkDerivation {
  pname = "plasma-integration";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    breeze-qt5 kconfig kconfigwidgets kiconthemes kio knotifications kwayland
    libXcursor qtquickcontrols2
  ];
}
