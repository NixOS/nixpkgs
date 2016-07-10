{ plasmaPackage, extra-cmake-modules
, breeze-qt5, kconfig, kconfigwidgets, kiconthemes, kio, kwayland
, libXcursor
}:

# TODO: install Noto Sans and Oxygen Mono fonts with plasma-integration

plasmaPackage {
  name = "plasma-integration";
  nativeBuildInputs = [
    extra-cmake-modules
  ];
  buildInputs = [
    breeze-qt5 kconfig kconfigwidgets kiconthemes kio kwayland
    libXcursor
  ];
}
