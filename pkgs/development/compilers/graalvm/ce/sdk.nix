{ stdenv
, lib
, llvm
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
, zlib
}:

stdenv.mkDerivation rec {
  version = sdkVersion;
  pname = "sdk";
  src = graalVMSource;
  buildInputs = [
    llvm mx ninja python27withPackages
    mercurial_4 jvmci zlib
    stdenv.cc.bintools.libc.bin
  ];

  patches = [ ./mx_truffle.py.patch ./mx_compiler.py.patch ./sulong_llvm_setjmp.patch ];

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

    substituteInPlace sulong/mx.sulong/suite.py \
      --replace '<path:LLVM_TOOLCHAIN>' '${llvm}'

    substituteInPlace sulong/mx.sulong/mx_sulong.py \
      --replace '#!/usr/bin/env bash' '#!${bash}/bin/bash'

    substituteInPlace sulong/tests/com.oracle.truffle.llvm.tests.native/Makefile \
      --replace '$(CLANG)' '$(CLANG) $(EXTRA_CFLAGS) -fuse-ld=lld -nostdlib'

    substituteInPlace sulong/projects/com.oracle.truffle.llvm.libraries.mock/Makefile \
      --replace '$(CLANG)' '$(CLANG) $(EXTRA_CFLAGS) -fuse-ld=lld -nostdlib'

    substituteInPlace sulong/projects/com.oracle.truffle.llvm.libraries.native/Makefile \
      --replace '$(CLANG)' '$(CLANG) $(EXTRA_CFLAGS) -fuse-ld=lld -nostdlib'

    substituteInPlace sulong/tests/com.oracle.truffle.llvm.tests.tck.native/Makefile \
      --replace '$(CLANG)' '$(CLANG) $(EXTRA_CFLAGS) -fuse-ld=lld -nostdlib'

    patchShebangs substratevm/mx.substratevm/rebuild-images.sh
  '';

  EXTRA_CFLAGS = "-I${stdenv.cc.bintools.libc.dev}/include -I${llvm}/include";

  buildPhase = ''
    export MX_GIT_CACHE='refcache'
    export JAVA_HOME=/build/openjdk
    export JVMCI_VERSION_CHECK='ignore'
    export JAVA_HOME=$NIX_BUILD_TOP/jvmci

    cd vm
    mx-internal \
     --max-cpus 1 \
     --dynamicimports substratevm,sulong,vm \
     --suite compiler \
     --suite sdk \
     --suite vm \
     --suite tools \
     --suite regex \
     --suite truffle \
     --suite sulong \
     build
  '';

  installPhase = ''
    mkdir -p $out
    rm -rf $MX_NIX_OUTPUT_ROOT/GRAALVM_*STAGE1*
    cp -rf $MX_NIX_OUTPUT_ROOT/GRAALVM*/graalvm-unknown*/{bin,include,jre,lib,release,share} $out
  '';

  preFixup = jvmci.preFixup;
  postFixup = openjdk.postFixup or null;
  dontStrip = true; # stripped javac crashes with "segmentaion fault"
}
