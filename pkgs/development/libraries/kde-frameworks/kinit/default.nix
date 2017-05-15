{
  mkDerivation, lib, copyPathsToStore,
  extra-cmake-modules, kdoctools,
  kconfig, kcrash, ki18n, kio, kparts, kservice, kwindowsystem, plasma-framework
}:

let inherit (lib) getLib; in

mkDerivation {
  name = "kinit";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  propagatedBuildInputs = [
    kconfig kcrash ki18n kio kservice kwindowsystem
  ];
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
  NIX_CFLAGS_COMPILE = [
    ''-DNIXPKGS_KF5_KIOCORE="${getLib kio}/lib/libKF5KIOCore.so.5"''
    ''-DNIXPKGS_KF5_PARTS="${getLib kparts}/lib/libKF5Parts.so.5"''
    ''-DNIXPKGS_KF5_PLASMA="${getLib plasma-framework}/lib/libKF5Plasma.so.5"''
  ];
}
