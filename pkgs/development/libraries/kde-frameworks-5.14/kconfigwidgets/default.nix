{ kdeFramework, lib
, extra-cmake-modules
, kauth
, kcodecs
, kconfig
, kdoctools
, kguiaddons
, ki18n
, kwidgetsaddons
}:

kdeFramework {
  name = "kconfigwidgets";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ kguiaddons ki18n ];
  propagatedBuildInputs = [ kauth kconfig kcodecs kwidgetsaddons ];
  patches = [ ./kconfigwidgets-helpclient-follow-symlinks.patch ];
  postInstall = ''
    wrapKDEProgram "$out/bin/preparetips5"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
