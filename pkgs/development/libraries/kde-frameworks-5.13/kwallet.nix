{ kdeFramework, lib
, extra-cmake-modules
, kconfig
, kcoreaddons
, kdbusaddons
, kdoctools
, ki18n
, kiconthemes
, knotifications
, kservice
, kwidgetsaddons
, kwindowsystem
, libgcrypt
}:

kdeFramework {
  name = "kwallet";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kconfig kcoreaddons kdbusaddons ki18n kiconthemes knotifications
    kservice kwidgetsaddons kwindowsystem libgcrypt
  ];
  postInstall = ''
    wrapKDEProgram "$out/bin/kwalletd5"
    wrapKDEProgram "$out/bin/kwallet-query"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
