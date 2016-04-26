{ kdeFramework, lib, copyPathsToStore
, extra-cmake-modules
, karchive
, kconfig
, kcoreaddons
, kdoctools
, ki18n
, makeQtWrapper
}:

kdeFramework {
  name = "kpackage";
  nativeBuildInputs = [ extra-cmake-modules kdoctools makeQtWrapper ];
  buildInputs = [ karchive kconfig ];
  propagatedBuildInputs = [ kcoreaddons ki18n ];
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
  postInstall = ''
    wrapQtProgram "$out/bin/kpackagetool5"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
