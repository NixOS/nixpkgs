{ kdeFramework, lib, extra-cmake-modules, kconfig, kcoreaddons
, kdbusaddons, kdoctools, ki18n, kiconthemes, knotifications
, kservice, kwidgetsaddons, kwindowsystem, libgcrypt
}:

kdeFramework {
  name = "kwallet";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kconfig kcoreaddons kdbusaddons kiconthemes knotifications
    kservice kwidgetsaddons kwindowsystem libgcrypt
  ];
  propagatedBuildInputs = [ ki18n ];
  postInstall = ''
    wrapKDEProgram "$out/bin/kwalletd5"
    wrapKDEProgram "$out/bin/kwallet-query"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
