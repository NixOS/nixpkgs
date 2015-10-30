{ kdeFramework, lib
, extra-cmake-modules
, kauth
, kconfig
, kcoreaddons
, kcrash
, kdbusaddons
, kfilemetadata
, ki18n
, kidletime
, kio
, lmdb
, qtbase
, qtquick1
, solid
}:

kdeFramework {
  name = "baloo";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kauth
    kconfig
    kcrash
    kdbusaddons
    ki18n
    kidletime
    kio
    lmdb
    qtquick1
    solid
  ];
  propagatedBuildInputs = [
    kcoreaddons
    kfilemetadata
    qtbase
  ];
  postInstall = ''
    wrapKDEProgram "$out/bin/baloo_file"
    wrapKDEProgram "$out/bin/baloo_file_extractor"
    wrapKDEProgram "$out/bin/balooctl"
    wrapKDEProgram "$out/bin/baloosearch"
    wrapKDEProgram "$out/bin/balooshow"
    wrapKDEProgram "$out/bin/baloo-monitor"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
