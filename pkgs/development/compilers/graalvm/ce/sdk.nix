{ stdenv
, lib
, bash
, sdkVersion
, graalVMSource
, jvmci
, openjdk
, makeMxCache
, makeMxGitCache
, mx
, ninja
, python27withPackages
, mercurial_4
, clang
, zlib
}:

stdenv.mkDerivation rec {
  version = sdkVersion;
  pname = "sdk";
  src = graalVMSource;
  buildInputs = [
    mx clang ninja python27withPackages
    mercurial_4 jvmci zlib
  ];

  patches = [ ./mx_truffle.py.patch ./mx_compiler.py.patch ];

  postUnpack = ''

    export MX_CACHE_DIR=$NIX_BUILD_TOP/mxcache
    export MX_GIT_CACHE_DIR=$NIX_BUILD_TOP/$sourceRoot
    export MX_ALT_OUTPUT_ROOT=$NIX_BUILD_TOP
    export MX_NIX_OUTPUT_ROOT=$MX_ALT_OUTPUT_ROOT
    ${makeMxCache { depList = (import ./graal-mxcache.nix { inherit stdenv lib; }); outputDir = "$MX_CACHE_DIR"; }}

    ( cd $MX_GIT_CACHE_DIR
      hg init
      hg add
      hg commit -m 'dummy commit'
      hg tag      ${sdkVersion}
      hg checkout ${sdkVersion}
    )

    mkdir $NIX_BUILD_TOP/jvmci
    cp -dpR ${jvmci}/* $NIX_BUILD_TOP/jvmci
    chmod +w -R $NIX_BUILD_TOP/jvmci

    # replace truffle makefile
    cp ${./truffle.make} /build/truffle.make
    rm $sourceRoot/truffle/src/libffi/patches/others/0001-Add-mx-bootstrap-Makefile.patch
  '';

  postPatch = ''
    # preventing unneccecary version control aborts
    substituteInPlace substratevm/mx.substratevm/mx_substratevm.py \
      --replace 'mx.abort' 'mx.warn'

    # Patch the native-image template, as it will be run during build
    substituteInPlace sdk/mx.sdk/vm/launcher_template.sh \
      --replace '/usr/bin/env bash' ${bash}/bin/bash \
      --replace "exec \"\''${location}/<jre_bin>/java\"" \
                "exec \''${location}/../../../../bin/java"

    substituteInPlace truffle/mx.truffle/macro-truffle.properties \
      --replace '-H:MaxRuntimeCompileMethods=1400' \
                '-H:MaxRuntimeCompileMethods=2800'

    patchShebangs substratevm/mx.substratevm/rebuild-images.sh
  '';

  buildPhase = ''
    export MX_GIT_CACHE='refcache'
    export JAVA_HOME=/build/openjdk
    export JVMCI_VERSION_CHECK='ignore'
    export JAVA_HOME=$NIX_BUILD_TOP/jvmci

    cd vm
    mx-internal \
     --max-cpus 1 \
     --dynamicimports substratevm \
     --suite compiler \
     --suite sdk \
     --suite vm \
     --suite tools \
     --suite regex \
     --suite truffle \
     build
  '';

  installPhase = ''
    mkdir -p $out
    rm -rf $MX_NIX_OUTPUT_ROOT/GRAALVM_*STAGE1*
    cp -rf $MX_NIX_OUTPUT_ROOT/GRAALVM*/graalvm-unknown*/{bin,include,jre,lib,share} $out
  '';

  preFixup = jvmci.preFixup;
  postFixup = openjdk.postFixup or null;
  dontStrip = true; # stripped javac crashes with "segmentaion fault"
}
