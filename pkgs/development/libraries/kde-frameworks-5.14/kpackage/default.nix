{ kdeFramework, lib
, extra-cmake-modules
, karchive
, kconfig
, kcoreaddons
, kdoctools
, ki18n
}:

kdeFramework {
  name = "kpackage";
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [ karchive kconfig ki18n ];
  propagatedBuildInputs = [ kcoreaddons ];
  patches = [ ./0001-allow-external-paths.patch ];
  postInstall = ''
    wrapKDEProgram "$out/bin/kpackagetool5"
  '';
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
