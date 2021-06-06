{ lib, pkgs, pkgsHostHost, makeWrapper, autoPatchelfHook
, deployAndroidPackage, package, os, platform-tools
}:

let
  runtime_paths = lib.makeBinPath (with pkgsHostHost; [
    coreutils file findutils gawk gnugrep gnused jdk python3 which
  ]) + ":${platform-tools}/platform-tools";
in
deployAndroidPackage {
  inherit package os;
  nativeBuildInputs = [ autoPatchelfHook makeWrapper ];
  buildInputs = lib.optional (os == "linux") [ pkgs.glibc pkgs.stdenv.cc.cc pkgs.python2 pkgs.ncurses5 pkgs.zlib pkgs.libcxx.out pkgs.libxml2 ];
  patchInstructions = lib.optionalString (os == "linux") (''
    patchShebangs .

    # Fix the shebangs of the auto-generated scripts.
    substituteInPlace ./build/tools/make_standalone_toolchain.py \
      --replace '#!/bin/bash' '#!${pkgs.bash}/bin/bash'

  '' + lib.optionalString (builtins.compareVersions (lib.getVersion package) "21" > 0) ''
    patch -p1 \
      --no-backup-if-mismatch < ${./make_standalone_toolchain.py_18.patch} || true
    wrapProgram ./build/tools/make_standalone_toolchain.py --prefix PATH : "${runtime_paths}"
  '' + ''

    # TODO: allow this stuff
    rm -rf docs tests

    # Patch the executables of the toolchains, but not the libraries -- they are needed for crosscompiling
    if [ -d $out/libexec/android-sdk/ndk-bundle/toolchains/renderscript/prebuilt/linux-x86_64/lib64 ]; then
        addAutoPatchelfSearchPath $out/libexec/android-sdk/ndk-bundle/toolchains/renderscript/prebuilt/linux-x86_64/lib64
    fi

    if [ -d $out/libexec/android-sdk/ndk-bundle/toolchains/llvm/prebuilt/linux-x86_64/lib64 ]; then
        addAutoPatchelfSearchPath $out/libexec/android-sdk/ndk-bundle/toolchains/llvm/prebuilt/linux-x86_64/lib64
    fi

    find toolchains -type d -name bin -or -name lib64 | while read dir; do
        autoPatchelf "$dir"
    done

    # fix ineffective PROGDIR / MYNDKDIR determination
    for progname in ndk-build; do
        sed -i -e 's|^PROGDIR=`dirname $0`|PROGDIR=`dirname $(readlink -f $(which $0))`|' $progname
    done

    # Patch executables
    autoPatchelf prebuilt/linux-x86_64

    # wrap
    for progname in ndk-build; do
        wrapProgram "$(pwd)/$progname" --prefix PATH : "${runtime_paths}"
    done

    # make some executables available in PATH
    mkdir -p $out/bin
    for progname in ndk-build; do
        ln -sf ../libexec/android-sdk/ndk-bundle/$progname $out/bin/$progname
    done
  '');
  noAuditTmpdir = true; # Audit script gets invoked by the build/ component in the path for the make standalone script
}
