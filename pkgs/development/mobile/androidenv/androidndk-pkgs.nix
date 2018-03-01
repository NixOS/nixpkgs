{ lib, hostPlatform, targetPlatform
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
    "arm-unknown-linux-androideabi" = {
      arch = "arm";
      triple = "arm-linux-androideabi";
      gccVer = "4.8";
    };
    "aarch64-unknown-linux-android" = {
      arch = "arm64";
      triple = "aarch64-linux-android";
      gccVer = "4.9";
    };
  }.${config} or
    (throw "Android NDK doesn't support ${config}, as far as we know");

  hostInfo = ndkInfoFun hostPlatform;
  targetInfo = ndkInfoFun targetPlatform;

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
        ln -s $prog $out/bin/${targetPlatform.config}-$prog_suffix
      done
    '';

  binutils = wrapBintoolsWith {
    bintools = binaries;
    libc = targetAndroidndkPkgs.libraries;
  };

  gcc = wrapCCWith {
    cc = binaries;
    bintools = binutils;
    libc = targetAndroidndkPkgs.libraries;
    extraBuildCommands =
      # GCC 4.9 is the first relase with "-fstack-protector"
      lib.optionalString (lib.versionOlder targetInfo.gccVer "4.9") ''
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
  libraries = {
    name = "bionic-prebuilt";
    type = "derivation";
    outPath = "${buildAndroidndk}/libexec/${buildAndroidndk.name}/platforms/android-21/arch-${hostInfo.arch}/usr/";
    drvPath = throw "fake derivation, build ${buildAndroidndk} to use";
  };
}
