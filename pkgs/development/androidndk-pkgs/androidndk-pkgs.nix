{ stdenv
, makeWrapper
, runCommand, wrapBintoolsWith, wrapCCWith
, buildAndroidndk, androidndk, targetAndroidndkPkgs
}:

let
  # Mapping from a platform to information needed to unpack NDK stuff for that
  # platform.
  #
  # N.B. The Android NDK uses slightly different LLVM-style platform triples
  # than we do. We don't just use theirs because ours are less ambiguous and
  # some builds need that clarity.
  ndkInfoFun = { config, ... }: {
    x86_64-apple-darwin = {
      double = "darwin-x86_64";
    };
    x86_64-unknown-linux-gnu = {
      double = "linux-x86_64";
    };
    i686-unknown-linux-android = {
      triple = "i686-linux-android";
      arch = "x86";
      toolchain = "x86";
      gccVer = "4.9";
    };
    x86_64-unknown-linux-android = {
      triple = "x86_64-linux-android";
      arch = "x86_64";
      toolchain = "x86_64";
      gccVer = "4.9";
    };
    armv7a-unknown-linux-androideabi = {
      arch = "arm";
      triple = "arm-linux-androideabi";
      toolchain = "arm-linux-androideabi";
      gccVer = "4.9";
    };
    aarch64-unknown-linux-android = {
      arch = "arm64";
      triple = "aarch64-linux-android";
      toolchain = "aarch64-linux-android";
      gccVer = "4.9";
    };
  }.${config} or
    (throw "Android NDK doesn't support ${config}, as far as we know");

  hostInfo = ndkInfoFun stdenv.hostPlatform;
  targetInfo = ndkInfoFun stdenv.targetPlatform;

  prefix = stdenv.lib.optionalString (stdenv.targetPlatform != stdenv.hostPlatform) (stdenv.targetPlatform.config + "-");
in

rec {
  # Misc tools
  binaries = runCommand "ndk-gcc-binutils" {
    isClang = true; # clang based cc, but bintools ld
    nativeBuildInputs = [ makeWrapper ];
    propagatedBuildInputs = [ androidndk ];
  } ''
    mkdir -p $out/bin

    # llvm toolchain
    for prog in ${androidndk}/libexec/android-sdk/ndk-bundle/toolchains/llvm/prebuilt/${hostInfo.double}/bin/*; do
      ln -s $prog $out/bin/$(basename $prog)
      ln -s $prog $out/bin/${prefix}$(basename $prog)
    done

    # bintools toolchain
    for prog in ${androidndk}/libexec/android-sdk/ndk-bundle/toolchains/${targetInfo.toolchain}-${targetInfo.gccVer}/prebuilt/${hostInfo.double}/bin/*; do
      prog_suffix=$(basename $prog | sed 's/${targetInfo.triple}-//')
      ln -s $prog $out/bin/${stdenv.targetPlatform.config}-$prog_suffix
    done

    # shitty googly wrappers
    rm -f $out/bin/${stdenv.targetPlatform.config}-gcc $out/bin/${stdenv.targetPlatform.config}-g++
  '';

  binutils = wrapBintoolsWith {
    bintools = binaries;
    libc = targetAndroidndkPkgs.libraries;
  };

  clang = wrapCCWith {
    cc = binaries;
    bintools = binutils;
    libc = targetAndroidndkPkgs.libraries;
    extraBuildCommands = ''
      echo "-D__ANDROID_API__=${stdenv.targetPlatform.sdkVer}" >> $out/nix-support/cc-cflags
      echo "-target ${stdenv.targetPlatform.config}" >> $out/nix-support/cc-cflags
      echo "-resource-dir=$(echo ${androidndk}/libexec/android-sdk/ndk-bundle/toolchains/llvm/prebuilt/${hostInfo.double}/lib*/clang/*)" >> $out/nix-support/cc-cflags
      echo "--gcc-toolchain=${androidndk}/libexec/android-sdk/ndk-bundle/toolchains/${targetInfo.toolchain}-${targetInfo.gccVer}/prebuilt/${hostInfo.double}" >> $out/nix-support/cc-cflags
    '';
  };

  # Bionic lib C and other libraries.
  #
  # We use androidndk from the previous stage, else we waste time or get cycles
  # cross-compiling packages to wrap incorrectly wrap binaries we don't include
  # anyways.
  libraries = runCommand "bionic-prebuilt" {} ''
    mkdir -p $out
    cp -r ${buildAndroidndk}/libexec/android-sdk/ndk-bundle/sysroot/usr/include $out/include
    chmod +w $out/include
    cp -r ${buildAndroidndk}/libexec/android-sdk/ndk-bundle/sysroot/usr/include/${targetInfo.triple}/* $out/include
    ln -s ${buildAndroidndk}/libexec/android-sdk/ndk-bundle/platforms/android-${stdenv.hostPlatform.sdkVer}/arch-${hostInfo.arch}/usr/${if hostInfo.arch == "x86_64" then "lib64" else "lib"} $out/lib
  '';
}
