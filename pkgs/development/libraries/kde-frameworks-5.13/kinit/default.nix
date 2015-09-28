{ mkDerivation, lib
, extra-cmake-modules
, kconfig
, kcrash
, kdoctools
, ki18n
, kio
, kservice
, kwindowsystem
, libcap
, libcap_progs
}:

# TODO: setuid wrapper

mkDerivation {
  name = "kinit";
  nativeBuildInputs = [ extra-cmake-modules kdoctools libcap_progs ];
  buildInputs = [ kconfig kcrash ki18n kio kservice kwindowsystem libcap ];
  patches = [ ./0001-kinit-libpath.patch ];
  meta = {
    maintainers = [ lib.maintainers.ttuegel ];
  };
}
