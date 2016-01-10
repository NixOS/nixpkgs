{ kdeFramework, lib, extra-cmake-modules, kauth, kconfig
, kcoreaddons, kcrash, kdbusaddons, kfilemetadata, ki18n, kidletime
, kio, lmdb, makeQtWrapper, qtbase, qtquick1, solid
}:

kdeFramework {
  name = "baloo";
  nativeBuildInputs = [ extra-cmake-modules makeQtWrapper ];
  buildInputs = [
    kconfig kcrash kdbusaddons lmdb qtquick1 solid
  ];
  propagatedBuildInputs = [
    kauth kcoreaddons kfilemetadata ki18n kio kidletime qtbase
  ];
  postInstall = ''
    wrapQtProgram "$out/bin/baloo_file"
    wrapQtProgram "$out/bin/baloo_file_extractor"
    wrapQtProgram "$out/bin/balooctl"
    wrapQtProgram "$out/bin/baloosearch"
    wrapQtProgram "$out/bin/balooshow"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
