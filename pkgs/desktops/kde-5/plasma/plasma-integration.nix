{ plasmaPackage, ecm
, breeze-qt5, kconfig, kconfigwidgets, kiconthemes, kio, kwayland
, libXcursor
}:

# TODO: install Noto Sans and Oxygen Mono fonts with plasma-integration

plasmaPackage {
  name = "plasma-integration";
  nativeBuildInputs = [
    ecm
  ];
  buildInputs = [
    breeze-qt5 kconfig kconfigwidgets kiconthemes kio kwayland
    libXcursor
  ];
}
