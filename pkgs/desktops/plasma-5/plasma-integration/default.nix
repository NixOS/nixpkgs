{
  mkDerivation,
  extra-cmake-modules,
  breeze-qt5, kconfig, kconfigwidgets, kiconthemes, kio, knotifications,
  kwayland, libXcursor, qtquickcontrols2
}:

# TODO: install Noto Sans and Oxygen Mono fonts with plasma-integration

mkDerivation {
  name = "plasma-integration";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    breeze-qt5 kconfig kconfigwidgets kiconthemes kio knotifications kwayland
    libXcursor qtquickcontrols2
  ];
  patches = [
    # See also: https://phabricator.kde.org/D9070
    # ttuegel: The patch is checked into Nixpkgs because I could not get
    # Phabricator to give me a stable link to it.
    ./D9070.patch
  ];
  patchFlags = "-p0";
}
