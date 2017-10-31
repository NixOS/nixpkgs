{
  mkDerivation, lib, copyPathsToStore, writeScript,
  extra-cmake-modules, kdoctools,
  kconfig, kcrash, ki18n, kio, kparts, kservice, kwindowsystem, plasma-framework
}:

let inherit (lib) getLib; in

mkDerivation {
  name = "kinit";
  meta = { maintainers = [ lib.maintainers.ttuegel ]; };
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kconfig kcrash ki18n kio kservice kwindowsystem
  ];
  patches = copyPathsToStore (lib.readPathsFromFile ./. ./series);
  NIX_CFLAGS_COMPILE = [
    ''-DNIXPKGS_KF5_KIOCORE="${getLib kio}/lib/libKF5KIOCore.so.5"''
    ''-DNIXPKGS_KF5_PARTS="${getLib kparts}/lib/libKF5Parts.so.5"''
    ''-DNIXPKGS_KF5_PLASMA="${getLib plasma-framework}/lib/libKF5Plasma.so.5"''
  ];
  postFixup = ''
    moveToOutput "lib/libexec/kf5/start_kdeinit" "$bin"
  '';
  setupHook = writeScript "setup-hook.sh" ''
    kinitFixupOutputHook() {
        if [ $prefix != ''${!outputBin} ] && [ -d $prefix/lib ]; then
            mkdir -p ''${!outputBin}/lib
            find $prefix/lib -maxdepth 1 -name 'libkdeinit5_*.so' -exec ln -s \{\} ''${!outputBin}/lib \;
            rmdir --ignore-fail-on-non-empty ''${!outputBin}/lib
        fi
    }

    fixupOutputHooks+=(kinitFixupOutputHook)
  '';
}
