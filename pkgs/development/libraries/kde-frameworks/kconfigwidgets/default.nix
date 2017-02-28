{
  kdeFramework, lib, extra-cmake-modules,
  kauth, kcodecs, kconfig, kdoctools, kguiaddons, ki18n, kwidgetsaddons
}:

kdeFramework {
  name = "kconfigwidgets";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    kauth kconfig kcodecs kguiaddons ki18n kwidgetsaddons
  ];
  patches = [ ./0001-qdiriterator-follow-symlinks.patch ];
  postInstall = ''
    moveToOutput "bin/preparetips5" "$dev"
  '';
}
