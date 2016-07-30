{
  kdeApp, ecm, kdoctools, makeQtWrapper,
  grantlee, kconfig, kcoreaddons, kdbusaddons, ki18n, kinit, kcmutils,
  kdelibs4support, khtml, kservice, xapian
}:

kdeApp {
  name = "khelpcenter";
  nativeBuildInputs = [ ecm kdoctools makeQtWrapper ];
  buildInputs = [
    grantlee kdelibs4support khtml ki18n kconfig kcoreaddons kdbusaddons kinit
    kcmutils kservice xapian
  ];
  postInstall = ''
    wrapQtProgram "$out/bin/khelpcenter"
  '';
}
