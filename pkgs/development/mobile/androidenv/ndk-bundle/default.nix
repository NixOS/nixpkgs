{ stdenv, lib, pkgs, pkgsHostHost, makeWrapper, autoPatchelfHook
, deployAndroidPackage, package, os, platform-tools
}:

let
  runtime_paths = lib.makeBinPath (with pkgsHostHost; [
    coreutils file findutils gawk gnugrep gnused jdk python3 which
  ]) + ":${platform-tools}/platform-tools";
in
deployAndroidPackage rec {
  inherit package os;
  nativeBuildInputs = [ makeWrapper ]
    ++ lib.optionals stdenv.isLinux [ autoPatchelfHook ];
  autoPatchelfIgnoreMissingDeps = [ "*" ];
  buildInputs = lib.optionals (os == "linux") [ pkgs.zlib pkgs.libcxx stdenv.cc.cc.lib ];

  patchElfBnaries = ''
    # Patch the executables of the toolchains, but not the libraries -- they are needed for crosscompiling
    if [ -d $out/libexec/android-sdk/ndk-bundle/toolchains/renderscript/prebuilt/linux-x86_64/lib64 ]; then
      addAutoPatchelfSearchPath $out/libexec/android-sdk/ndk-bundle/toolchains/renderscript/prebuilt/linux-x86_64/lib64
    fi

    if [ -d $out/libexec/android-sdk/ndk-bundle/toolchains/llvm/prebuilt/linux-x86_64/lib64 ]; then
      addAutoPatchelfSearchPath $out/libexec/android-sdk/ndk-bundle/toolchains/llvm/prebuilt/linux-x86_64/lib64
    fi

    if [ -d $out/libexec/android-sdk/ndk-bundle/toolchains/llvm/prebuilt/linux-x86_64/lib ]; then
      addAutoPatchelfSearchPath $out/libexec/android-sdk/ndk-bundle/toolchains/llvm/prebuilt/linux-x86_64/lib
    fi

    find toolchains -type d -name bin -or -name lib64 -or -name lib | while read dir; do
      autoPatchelf "$dir"
    done

    # Patch executables
    if [ -d prebuilt/linux-x86_64 ]; then
      autoPatchelf prebuilt/linux-x86_64
    fi
  '';

  patchOsAgnostic = ''
    patchShebangs .

    # TODO: allow this stuff
    rm -rf docs tests

    # Ndk now has a prebuilt toolchains inside, the file layout has changed, we do a symlink
    # to still support the old standalone toolchains builds.
    if [ -d $out/libexec/android-sdk/ndk ] && [ ! -d $out/libexec/android-sdk/ndk-bundle ]; then
      ln -sf $out/libexec/android-sdk/ndk/${package.revision} $out/libexec/android-sdk/ndk-bundle
    elif [ ! -d $out/libexec/android-sdk/ndk-bundle ]; then
      echo "The ndk-bundle layout has changed. The nix expressions have to be updated!"
      exit 1
    fi

    # fix ineffective PROGDIR / MYNDKDIR determination
    for progname in ndk-build; do
      sed -i -e 's|^PROGDIR=`dirname $0`|PROGDIR=`dirname $(readlink -f $(which $0))`|' $progname
    done

    # wrap
    for progname in ndk-build; do
      wrapProgram "$(pwd)/$progname" --prefix PATH : "${runtime_paths}"
    done

    # make some executables available in PATH
    mkdir -p $out/bin
    for progname in ndk-build; do
      ln -sf ../libexec/android-sdk/ndk-bundle/$progname $out/bin/$progname
    done
  '';

  patchInstructions = patchOsAgnostic
    + lib.optionalString stdenv.isLinux patchElfBnaries;

  noAuditTmpdir = true; # Audit script gets invoked by the build/ component in the path for the make standalone script
}
