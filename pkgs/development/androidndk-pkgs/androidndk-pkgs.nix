{ lib, stdenv
, makeWrapper, python
, runCommand, wrapBintoolsWith, wrapCCWith, autoPatchelfHook
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

  sdkVer = stdenv.targetPlatform.sdkVer;

  # targetInfo.triple is what Google thinks the toolchain should be, this is a little
  # different from what we use. We make it four parts to conform with the existing
  # standard more properly.
  targetConfig = lib.optionalString (stdenv.targetPlatform != stdenv.hostPlatform) (stdenv.targetPlatform.config);
in

rec {
  # Misc tools
  binaries = stdenv.mkDerivation {
    pname = "${targetConfig}-ndk-toolchain";
    inherit (androidndk) version;
    isClang = true; # clang based cc, but bintools ld
    nativeBuildInputs = [ makeWrapper python autoPatchelfHook ];

    propagatedBuildInputs = [ androidndk ];
    dontUnpack = true;
    dontBuild = true;
    dontStrip = true;
    dontConfigure = true;
    dontPatch = true;
    autoPatchelfIgnoreMissingDeps = true;
    installPhase = ''
      ${androidndk}/libexec/android-sdk/ndk-bundle/build/tools/make-standalone-toolchain.sh --arch=${targetInfo.arch} --install-dir=$out/toolchain --platform=${sdkVer} --force
      ln -vfs $out/toolchain/sysroot/usr/lib $out/lib
      ln -s $out/toolchain/sysroot/usr/lib/${targetInfo.triple}/*.so $out/lib/
      ln -s $out/toolchain/sysroot/usr/lib/${targetInfo.triple}/*.a $out/lib/
      chmod +w $out/lib/*
      ln -s $out/toolchain/sysroot/usr/lib/${targetInfo.triple}/${sdkVer}/*.so $out/lib/
      ln -s $out/toolchain/sysroot/usr/lib/${targetInfo.triple}/${sdkVer}/*.o $out/lib/

      echo "INPUT(-lc++_static)" > $out/lib/libc++.a

      ln -s $out/toolchain/bin $out/bin
      ln -s $out/toolchain/${targetInfo.triple}/bin/* $out/bin/
      for f in $out/bin/${targetInfo.triple}-*; do
        ln -s $f ''${f/${targetInfo.triple}-/${targetConfig}-}
      done
      for f in `find $out/toolchain -type d -name ${targetInfo.triple}`; do
        ln -s $f ''${f/${targetInfo.triple}/${targetConfig}}
      done

      # get rid of gcc and g++, otherwise wrapCCWith will use them instead of clang
      rm $out/bin/${targetConfig}-gcc $out/bin/${targetConfig}-g++

      # ld doesn't properly include transitive library dependencies. Let's use gold
      # instead
      rm $out/bin/${targetConfig}-ld
      ln -s $out/bin/${targetConfig}-ld.gold $out/bin/${targetConfig}-ld

      patchShebangs $out/bin
    '';
  };

  binutils = wrapBintoolsWith {
    bintools = binaries;
    libc = targetAndroidndkPkgs.libraries;
  };

  clang = wrapCCWith {
    cc = binaries // {
      # for packages expecting libcompiler-rt, etc. to come from here (stdenv.cc.cc.lib)
      lib = targetAndroidndkPkgs.libraries;
    };
    bintools = binutils;
    libc = targetAndroidndkPkgs.libraries;
    extraBuildCommands = ''
      echo "-D__ANDROID_API__=${stdenv.targetPlatform.sdkVer}" >> $out/nix-support/cc-cflags
      echo "-resource-dir=$(echo ${androidndk}/libexec/android-sdk/ndk-bundle/toolchains/llvm/prebuilt/${hostInfo.double}/lib*/clang/*)" >> $out/nix-support/cc-cflags
      echo "--gcc-toolchain=${androidndk}/libexec/android-sdk/ndk-bundle/toolchains/${targetInfo.toolchain}-${targetInfo.gccVer}/prebuilt/${hostInfo.double}" >> $out/nix-support/cc-cflags
      echo "-fuse-ld=$out/bin/${targetConfig}-ld.gold -L${binaries}/lib" >> $out/nix-support/cc-ldflags
    '';
  };

  # Bionic lib C and other libraries.
  #
  # We use androidndk from the previous stage, else we waste time or get cycles
  # cross-compiling packages to wrap incorrectly wrap binaries we don't include
  # anyways.
  libraries = runCommand "bionic-prebuilt" {} ''
    mkdir -p $out/lib
    cp ${buildAndroidndk}/libexec/android-sdk/ndk-bundle/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/${targetInfo.triple}/*.so $out/lib
    cp ${buildAndroidndk}/libexec/android-sdk/ndk-bundle/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/${targetInfo.triple}/*.a $out/lib
    chmod +w $out/lib/*
    cp ${buildAndroidndk}/libexec/android-sdk/ndk-bundle/toolchains/llvm/prebuilt/linux-x86_64/sysroot/usr/lib/${targetInfo.triple}/${sdkVer}/* $out/lib
  '';
}
