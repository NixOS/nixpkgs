{ kdeApp
, lib
, makeQtWrapper
, extra-cmake-modules
, gmp
, kdoctools
, kconfig
, kconfigwidgets
, kguiaddons
, kinit
, knotifications
}:

kdeApp {
  name = "kcalc";

  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];

  buildInputs = [
    gmp
    kconfig
    kconfigwidgets
    kguiaddons
    kinit
    knotifications
  ];

  postInstall = ''
    wrapQtProgram "$out/bin/kcalc"
  '';

  meta = {
    license = with lib.licenses; [ gpl2 ];
    maintainers = [ lib.maintainers.fridh ];
  };
}
