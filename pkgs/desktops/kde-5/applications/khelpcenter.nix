{ kdeApp, extra-cmake-modules, kdoctools, makeQtWrapper
, grantlee, kconfig, kcoreaddons, kdbusaddons, ki18n, kinit, kcmutils
, kdelibs4support, khtml, kservice
, xapian
}:

kdeApp {
  name = "khelpcenter";
  nativeBuildInputs = [
    extra-cmake-modules kdoctools makeQtWrapper
  ];
  buildInputs = [
    grantlee kdelibs4support khtml ki18n kconfig kcoreaddons kdbusaddons kinit
    kcmutils kservice
    xapian
  ];
  postInstall = ''
    wrapQtProgram "$out/bin/khelpcenter"
  '';
}
