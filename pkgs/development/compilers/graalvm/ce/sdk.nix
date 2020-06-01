{ stdenv
, lib
, bash
, callPackage
, glibc
, sdkVersion
, graalVMSource
, jvmci
, openjdk
, makeMxCache
, mx
, ninja
, python27withPackages
, mercurial_4
, zlib
}:

let
llvmHome = callPackage ./llvm.nix {};
result = stdenv.mkDerivation rec {
  version = sdkVersion;
  pname = "sdk";
  src = graalVMSource;
  buildInputs = [
    mx ninja python27withPackages
    mercurial_4 jvmci zlib
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
    cp ${./truffle.make} $NIX_BUILD_TOP/truffle.make
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

    substituteInPlace sdk/mx.sdk/mx_sdk_vm_impl.py \
      --replace 'use_relpath=True' 'use_relpath=False'

    substituteInPlace truffle/mx.truffle/macro-truffle.properties \
      --replace '-H:MaxRuntimeCompileMethods=1400' \
                '-H:MaxRuntimeCompileMethods=2800'

    substituteInPlace sulong/mx.sulong/suite.py \
      --replace '<path:LLVM_TOOLCHAIN>' '${llvmHome}'

    substituteInPlace sulong/mx.sulong/mx_sulong.py \
      --replace '#!/usr/bin/env bash' '#!${bash}/bin/bash'

    substituteInPlace sulong/projects/com.oracle.truffle.llvm.libraries.bitcode/Makefile \
      --replace '$(EXTRA_CXXFLAGS)' "-nostdlib -I${llvmHome}/include/c++/v1"

    substituteInPlace sulong/projects/com.oracle.truffle.llvm.toolchain.launchers/src/com/oracle/truffle/llvm/toolchain/launchers/common/Driver.java \
      --replace 'getLLVMExecutable(exe).toString()' '"${llvmHome}/bin/" + exe'

    # Always print compiler errors/warnings (this makes debugging in nix much more plesant)
    substituteInPlace substratevm/src/com.oracle.svm.hosted/src/com/oracle/svm/hosted/c/codegen/CCompilerInvoker.java \
      --replace '(String line : lines) {' '(String line : lines) {System.out.println(line);'

    patchShebangs substratevm/mx.substratevm/rebuild-images.sh

    # The patched llvm9 seems clueless about include locations
    for mkfile in $(find sulong -type f -name Makefile); do
      substituteInPlace $mkfile \
        --replace '$(CLANG)' '$(CLANG) -I${glibc.dev}/include -fuse-ld=lld -nostdlib' || true
      substituteInPlace $mkfile \
        --replace '$(CLANGXX)' '$(CLANGXX) -I${glibc.dev}/include -fuse-ld=lld -nostdlib' || true
    done
  '';

  buildPhase = ''
    export PATH=$PATH:${llvmHome}/bin
    export MX_GIT_CACHE='refcache'
    export JAVA_HOME=$NIX_BUILD_TOP/openjdk
    export JVMCI_VERSION_CHECK='ignore'
    export JAVA_HOME=$NIX_BUILD_TOP/jvmci

    ( cd vm
      mx-internal --max-cpus 1 --dynamicimports compiler,vm,regex,tools,truffle,sdk,substratevm,sulong build
    )
  '';

  installPhase = ''
    mkdir -p $out
    rm -rf $MX_NIX_OUTPUT_ROOT/GRAALVM_*STAGE1*
    cp -rf $MX_NIX_OUTPUT_ROOT/GRAALVM*/graalvm-unknown*/{bin,include,jre,lib,release,share} $out
    cp sulong/include/truffle.h $out/include

    find $out/jre/lib/llvm/bin -type f -executable -exec patchelf \
      --set-interpreter "$(cat $NIX_CC/nix-support/dynamic-linker)" \
      --set-rpath ${lib.makeLibraryPath [ zlib stdenv.cc.cc.lib ((placeholder "out") + "/jre/lib/llvm")]} '{}' \;
    find $out/jre/lib/llvm/lib -type f -name '*.so*' -exec patchelf \
      --set-rpath ${lib.makeLibraryPath [ zlib stdenv.cc.cc.lib ((placeholder "out") + "/jre/lib/llvm")]} '{}' \;

    # BUG workaround http://mail.openjdk.java.net/pipermail/graal-dev/2017-December/005141.html
    substituteInPlace $out/jre/lib/security/java.security \
      --replace file:/dev/random    file:/dev/./urandom \
      --replace NativePRNGBlocking  SHA1PRNG

    # copy static and dynamic libraries needed for static compilation
    cp -rf ${glibc}/lib/* $out/jre/lib/svm/clibraries/linux-amd64/
    cp ${glibc.static}/lib/* $out/jre/lib/svm/clibraries/linux-amd64/
    cp ${zlib.static}/lib/libz.a $out/jre/lib/svm/clibraries/linux-amd64/libz.a
  '';

  preFixup = jvmci.preFixup + ''
    cat <<EOF >> $out/nix-support/setup-hook
    if [ -z "\''${GRAALVM_HOME-}" ]; then export GRAALVM_HOME=$out; fi
    EOF
  '';
  postFixup = openjdk.postFixup or null;
  dontStrip = true; # stripped javac crashes with "segmentaion fault"

  enableParallelBuilding = true;
  passthru.home = result;
  passthru.jre = "${result}/jre";

  doInstallCheck = true;
  installCheckPhase = ''
    echo ${lib.escapeShellArg ''
      public class HelloWorld {
        public static void main(String[] args) {
          System.out.println("Hello World");
        }
      }
    ''} > HelloWorld.java
    $out/bin/javac HelloWorld.java

    # run on JVM with Graal Compiler
    $out/bin/java -XX:+UnlockExperimentalVMOptions -XX:+EnableJVMCI -XX:+UseJVMCICompiler HelloWorld
    $out/bin/java -XX:+UnlockExperimentalVMOptions -XX:+EnableJVMCI -XX:+UseJVMCICompiler HelloWorld | fgrep 'Hello World'

    # Ahead-Of-Time compilation
    $out/bin/native-image --no-server HelloWorld
    ./helloworld
    ./helloworld | fgrep 'Hello World'

    # Ahead-Of-Time compilation with --static
    $out/bin/native-image --no-server --static HelloWorld
    ./helloworld
    ./helloworld | fgrep 'Hello World'
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/oracle/graal;
    description = "High-Performance Polyglot VM";
    license = licenses.gpl2;
    maintainers = with maintainers; [ volth hlolli ];
    platforms = [ "x86_64-linux" "x86_64-darwin" /*"aarch64-linux"*/ ];
  };
}; in result
