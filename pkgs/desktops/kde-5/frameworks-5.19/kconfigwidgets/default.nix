{ kdeFramework, lib, extra-cmake-modules, kauth, kcodecs, kconfig
, kdoctools, kguiaddons, ki18n, kwidgetsaddons, makeQtWrapper
}:

kdeFramework {
  name = "kconfigwidgets";
  nativeBuildInputs = [ extra-cmake-modules kdoctools makeQtWrapper ];
  buildInputs = [ kguiaddons ];
  propagatedBuildInputs = [ kauth kconfig kcodecs ki18n kwidgetsaddons ];
  patches = [ ./0001-qdiriterator-follow-symlinks.patch ];
  postInstall = ''
    wrapQtProgram "$out/bin/preparetips5"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
