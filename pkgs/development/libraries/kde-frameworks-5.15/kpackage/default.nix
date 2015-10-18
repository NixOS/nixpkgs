{ kdeFramework, lib
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
  patches = [
    ./0001-allow-external-paths.patch
    ./0002-qdiriterator-follow-symlinks.patch
  ];
  postInstall = ''
    wrapQtProgram "$out/bin/kpackagetool5"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
