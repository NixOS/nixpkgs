{ kdeFramework, lib, extra-cmake-modules, kauth, kconfig
, kcoreaddons, kcrash, kdbusaddons, kfilemetadata, ki18n, kidletime
, kio, lmdb, makeQtWrapper, qtbase, solid
}:

kdeFramework {
  name = "baloo";
  nativeBuildInputs = [ extra-cmake-modules makeQtWrapper ];
  propagatedBuildInputs = [
    kauth kconfig kcoreaddons kcrash kdbusaddons kfilemetadata ki18n kio
    kidletime lmdb qtbase solid
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
