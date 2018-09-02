{ lib, stdenv
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
    "x86_64-unknown-linux-gnu" = {
      double = "linux-x86_64";
    };
    "armv5tel-unknown-linux-androideabi" = {
      arch = "arm";
      triple = "arm-linux-androideabi";
      gccVer = "4.8";
    };
    "armv7a-unknown-linux-androideabi" = {
      arch = "arm";
      triple = "arm-linux-androideabi";
      gccVer = "4.9";
    };
    "aarch64-unknown-linux-android" = {
      arch = "arm64";
      triple = "aarch64-linux-android";
      gccVer = "4.9";
    };
  }.${config} or
    (throw "Android NDK doesn't support ${config}, as far as we know");

  hostInfo = ndkInfoFun stdenv.hostPlatform;
  targetInfo = ndkInfoFun stdenv.targetPlatform;

in

rec {
  # Misc tools
  binaries = let
      ndkBinDir =
        "${androidndk}/libexec/${androidndk.name}/toolchains/${targetInfo.triple}-${targetInfo.gccVer}/prebuilt/${hostInfo.double}/bin";
    in runCommand "ndk-gcc-binutils" {
      isGNU = true; # for cc-wrapper
      nativeBuildInputs = [ makeWrapper ];
      propgatedBuildInputs = [ androidndk ];
    } ''
      mkdir -p $out/bin
      for prog in ${ndkBinDir}/${targetInfo.triple}-*; do
        prog_suffix=$(basename $prog | sed 's/${targetInfo.triple}-//')
        ln -s $prog $out/bin/${stdenv.targetPlatform.config}-$prog_suffix
      done
    '';

  binutils = wrapBintoolsWith {
    bintools = binaries;
    libc = targetAndroidndkPkgs.libraries;
    extraBuildCommands = ''
      echo "--build-id" >> $out/nix-support/libc-ldflags
    '';
  };

  gcc = wrapCCWith {
    cc = binaries;
    bintools = binutils;
    libc = targetAndroidndkPkgs.libraries;
    extraBuildCommands = ''
      echo "-D__ANDROID_API__=${stdenv.targetPlatform.sdkVer}" >> $out/nix-support/cc-cflags
    ''
    + lib.optionalString stdenv.targetPlatform.isAarch32 (let
        p =  stdenv.targetPlatform.platform.gcc or {}
          // stdenv.targetPlatform.parsed.abi;
        flags = lib.concatLists [
          (lib.optional (p ? arch) "-march=${p.arch}")
          (lib.optional (p ? cpu) "-mcpu=${p.cpu}")
          (lib.optional (p ? abi) "-mabi=${p.abi}")
          (lib.optional (p ? fpu) "-mfpu=${p.fpu}")
          (lib.optional (p ? float) "-mfloat=${p.float}")
          (lib.optional (p ? float-abi) "-mfloat-abi=${p.float-abi}")
          (lib.optional (p ? mode) "-mmode=${p.mode}")
        ];
      in ''
        sed -E -i \
          $out/bin/${stdenv.targetPlatform.config}-cc \
          $out/bin/${stdenv.targetPlatform.config}-c++ \
          $out/bin/${stdenv.targetPlatform.config}-gcc \
          $out/bin/${stdenv.targetPlatform.config}-g++ \
          -e '130i    extraBefore+=(-Wl,--fix-cortex-a8)' \
          -e 's|^(extraBefore=)\(\)$|\1(${builtins.toString flags})|'
      '')
      # GCC 4.9 is the first relase with "-fstack-protector"
      + lib.optionalString (lib.versionOlder targetInfo.gccVer "4.9") ''
        sed -E \
        -i $out/nix-support/add-hardening.sh \
        -e 's|(-fstack-protector)-strong|\1|g'
      '';
  };

  # Bionic lib C and other libraries.
  #
  # We use androidndk from the previous stage, else we waste time or get cycles
  # cross-compiling packages to wrap incorrectly wrap binaries we don't include
  # anyways.
  libraries =
    let
      includePath = if buildAndroidndk.version == "10e" then
          "${buildAndroidndk}/libexec/${buildAndroidndk.name}/platforms/android-${stdenv.hostPlatform.sdkVer}/arch-${hostInfo.arch}/usr/include/"
        else
          "${buildAndroidndk}/libexec/${buildAndroidndk.name}/sysroot/usr/include";
      libPath = "${buildAndroidndk}/libexec/${buildAndroidndk.name}/platforms/android-${stdenv.hostPlatform.sdkVer}/arch-${hostInfo.arch}/usr/lib/";
    in
    runCommand "bionic-prebuilt" {} ''
      mkdir -p $out
      cp -r ${includePath} $out/include
      chmod +w $out/include
      ${lib.optionalString (lib.versionOlder "10e" buildAndroidndk.version)
        "ln -s $out/include/${hostInfo.triple}/asm $out/include/asm"}
      ln -s ${libPath} $out/lib
    '';
}
