{
  mkDerivation, lib, stdenv, writeScript,
  extra-cmake-modules, kdoctools,
  kconfig, kcrash, ki18n, kio, kparts, kservice, kwindowsystem, plasma-framework
}:

let inherit (lib) getLib; in

mkDerivation {
  pname = "kinit";
  outputs = [ "out" "dev" ];
  nativeBuildInputs = [ extra-cmake-modules kdoctools ];
  buildInputs = [
    kconfig kcrash ki18n kio kservice kwindowsystem
  ];
  patches = [
    ./0002-start_kdeinit-path.patch
    ./0003-kdeinit-extra-libs.patch
    ./0004-start_kdeinit-environ-hard-limit.patch
  ];
  CXXFLAGS = [
    ''-DNIXPKGS_KF5_KIOCORE=\"${getLib kio}/lib/libKF5KIOCore.so.5\"''
    ''-DNIXPKGS_KF5_PARTS=\"${getLib kparts}/lib/libKF5Parts.so.5\"''
  ] ++ lib.optionals stdenv.isLinux [
    ''-DNIXPKGS_KF5_PLASMA=\"${getLib plasma-framework}/lib/libKF5Plasma.so.5\"''
  ];
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
