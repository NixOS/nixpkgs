{ lib, stdenv, makeWrapper
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
  #
  # FIXME:
  # There's some dragons here. Build host and target concepts are being mixed up.
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
    };
    x86_64-unknown-linux-android = {
      triple = "x86_64-linux-android";
      arch = "x86_64";
    };
    armv7a-unknown-linux-androideabi = {
      arch = "arm";
      triple = "arm-linux-androideabi";
    };
    aarch64-unknown-linux-android = {
      arch = "arm64";
      triple = "aarch64-linux-android";
    };
  }.${config} or
    (throw "Android NDK doesn't support ${config}, as far as we know");

  buildInfo = ndkInfoFun stdenv.buildPlatform;
  hostInfo = ndkInfoFun stdenv.hostPlatform;
  targetInfo = ndkInfoFun stdenv.targetPlatform;

  inherit (stdenv.targetPlatform) sdkVer;
  suffixSalt = lib.replaceStrings ["-" "."] ["_" "_"] stdenv.targetPlatform.config;

  # targetInfo.triple is what Google thinks the toolchain should be, this is a little
  # different from what we use. We make it four parts to conform with the existing
  # standard more properly.
  targetPrefix = lib.optionalString (stdenv.targetPlatform != stdenv.hostPlatform) (stdenv.targetPlatform.config + "-");
in

rec {
  # Misc tools
  binaries = stdenv.mkDerivation {
    pname = "${targetPrefix}ndk-toolchain";
    inherit (androidndk) version;
    nativeBuildInputs = [ makeWrapper autoPatchelfHook ];
    propagatedBuildInputs = [ androidndk ];
    passthru = {
      inherit targetPrefix;
      isClang = true; # clang based cc, but bintools ld
    };
    dontUnpack = true;
    dontBuild = true;
    dontStrip = true;
    dontConfigure = true;
    dontPatch = true;
    autoPatchelfIgnoreMissingDeps = true;
    installPhase = ''
      # https://developer.android.com/ndk/guides/other_build_systems
      mkdir -p $out
      cp -r ${androidndk}/libexec/android-sdk/ndk-bundle/toolchains/llvm/prebuilt/${buildInfo.double} $out/toolchain
      find $out/toolchain -type d -exec chmod 777 {} \;

      if [ ! -d $out/toolchain/sysroot/usr/lib/${targetInfo.triple}/${sdkVer} ]; then
        echo "NDK does not contain libraries for SDK version ${sdkVer}";
        exit 1
      fi

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
        ln -s $f ''${f/${targetInfo.triple}-/${targetPrefix}}
      done
      for f in $(find $out/toolchain -type d -name ${targetInfo.triple}); do
        ln -s $f ''${f/${targetInfo.triple}/${targetPrefix}}
      done

      rm -f $out/bin/${targetPrefix}ld
      ln -s $out/bin/lld $out/bin/${targetPrefix}ld

      (cd $out/bin;
        for tool in llvm-*; do
          ln -sf $tool ${targetPrefix}$(echo $tool | sed 's/llvm-//')
          ln -sf $tool $(echo $tool | sed 's/llvm-//')
        done)

      # handle last, as llvm-as is for llvm bytecode
      ln -sf $out/bin/${targetInfo.triple}-as $out/bin/${targetPrefix}as
      ln -sf $out/bin/${targetInfo.triple}-as $out/bin/as

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
      # Android needs executables linked with -pie since version 5.0
      # Use -fPIC for compilation, and link with -pie if no -shared flag used in ldflags
      echo "-target ${targetInfo.triple} -fPIC" >> $out/nix-support/cc-cflags
      echo "-z,noexecstack -z,relro -z,now -z,muldefs" >> $out/nix-support/cc-ldflags
      echo 'expandResponseParams "$@"' >> $out/nix-support/add-flags.sh
      echo 'if [[ ! (" ''${params[@]} " =~ " -shared ") && ! (" ''${params[@]} " =~ " -no-pie ") ]]; then NIX_LDFLAGS_${suffixSalt}+=" -pie"; fi' >> $out/nix-support/add-flags.sh
      echo "-Xclang -mnoexecstack" >> $out/nix-support/cc-cxxflags
      if [ ${targetInfo.triple} == arm-linux-androideabi ]; then
        # https://android.googlesource.com/platform/external/android-cmake/+/refs/heads/cmake-master-dev/android.toolchain.cmake
        echo "--fix-cortex-a8" >> $out/nix-support/cc-ldflags
      fi
    '';
  };

  # Bionic lib C and other libraries.
  #
  # We use androidndk from the previous stage, else we waste time or get cycles
  # cross-compiling packages to wrap incorrectly wrap binaries we don't include
  # anyways.
  libraries = runCommand "bionic-prebuilt" {} ''
    lpath=${buildAndroidndk}/libexec/android-sdk/ndk-bundle/toolchains/llvm/prebuilt/${buildInfo.double}/sysroot/usr/lib/${targetInfo.triple}/${sdkVer}
    if [ ! -d $lpath ]; then
      echo "NDK does not contain libraries for SDK version ${sdkVer} <$lpath>"
      exit 1
    fi
    mkdir -p $out/lib
    cp $lpath/*.so $lpath/*.a $out/lib
    chmod +w $out/lib/*
    cp $lpath/* $out/lib
  '';
}
