{ plasmaPackage
, extra-cmake-modules
, kdoctools
, kcoreaddons
, ki18n
, kwallet
, kwidgetsaddons
}:

plasmaPackage {
  name = "ksshaskpass";
  nativeBuildInputs = [
    extra-cmake-modules
    kdoctools
  ];
  buildInputs = [
    kcoreaddons
    ki18n
    kwallet
    kwidgetsaddons
  ];
  postInstall = ''
    wrapKDEProgram "$out/bin/ksshaskpass"
  '';
}
