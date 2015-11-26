{ kdeFramework, lib, extra-cmake-modules, kauth, kcodecs, kconfig
, kdoctools, kguiaddons, ki18n, kwidgetsaddons, makeKDEWrapper
}:

kdeFramework {
  name = "kconfigwidgets";
  nativeBuildInputs = [ extra-cmake-modules kdoctools makeKDEWrapper ];
  buildInputs = [ kguiaddons ];
  propagatedBuildInputs = [ kauth kconfig kcodecs ki18n kwidgetsaddons ];
  patches = [ ./0001-qdiriterator-follow-symlinks.patch ];
  postInstall = ''
    wrapKDEProgram "$out/bin/preparetips5"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
