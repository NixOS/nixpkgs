{ kdeFramework, lib, extra-cmake-modules, kauth, kconfig
, kcoreaddons, kcrash, kdbusaddons, kfilemetadata, ki18n, kidletime
, kio, lmdb, qtbase, qtquick1, solid
}:

kdeFramework {
  name = "baloo";
  nativeBuildInputs = [ extra-cmake-modules ];
  buildInputs = [
    kconfig kcrash kdbusaddons lmdb qtquick1 solid
  ];
  propagatedBuildInputs = [
    kauth kcoreaddons kfilemetadata ki18n kio kidletime qtbase
  ];
  postInstall = ''
    wrapKDEProgram "$out/bin/baloo_file"
    wrapKDEProgram "$out/bin/baloo_file_extractor"
    wrapKDEProgram "$out/bin/balooctl"
    wrapKDEProgram "$out/bin/baloosearch"
    wrapKDEProgram "$out/bin/balooshow"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
