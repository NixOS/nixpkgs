{ plasmaPackage
, extra-cmake-modules
, kdoctools
, kconfig
, kcoreaddons
, kdbusaddons
, ki18n
, kinit
, kcmutils
, kdelibs4support
, khtml
, kservice
}:

plasmaPackage {
  name = "khelpcenter";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    kconfig
    kcoreaddons
    kdbusaddons
    ki18n
    kinit
    kcmutils
    kdelibs4support
    khtml
    kservice
  ];
  postInstall = ''
    wrapKDEProgram "$out/bin/khelpcenter"
  '';
}
