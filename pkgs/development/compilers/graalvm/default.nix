{ stdenv, lib, fetchFromGitHub, fetchurl, fetchzip, mercurial, python27, zlib, makeWrapper, oraclejdk8 }:

let
  # pre-download some cache entries ('mx' will not be able to download under nixbld1)
  makeMxCache = list:
    stdenv.mkDerivation {
      name = "mx-cache";
      buildCommand = ''
        mkdir $out
        ${lib.concatMapStrings ({url, name, sha1}: ''
                                  install -D ${fetchurl { inherit url sha1; }} $out/${name}
                                  echo -n ${sha1} > $out/${name}.sha1
                                '') list}
      '';
    };

  jvmci8-mxcache = [
    rec { sha1 = "66215826a684eb6866d4c14a5a4f9c344f1d1eef"; name = "JACOCOCORE_${sha1}/jacococore.jar";                                               url = mirror://maven/org/jacoco/org.jacoco.core/0.7.9/org.jacoco.core-0.7.9.jar; }
    rec { sha1 = "a365ee459836b2aa18028929923923d15f0c3af9"; name = "JACOCOCORE_${sha1}/jacococore.sources.jar";                                       url = mirror://maven/org/jacoco/org.jacoco.core/0.7.9/org.jacoco.core-0.7.9-sources.jar; }
    rec { sha1 = "8a7f78fdf2a4e58762890d8e896a9298c2980c10"; name = "JACOCOREPORT_${sha1}/jacocoreport.jar";                                           url = mirror://maven/org/jacoco/org.jacoco.report/0.7.9/org.jacoco.report-0.7.9.jar; }
    rec { sha1 = "e6703ef288523a8e63fa756d8adeaa70858d41b0"; name = "JACOCOREPORT_${sha1}/jacocoreport.sources.jar";                                   url = mirror://maven/org/jacoco/org.jacoco.report/0.7.9/org.jacoco.report-0.7.9-sources.jar; }
    rec { sha1 = "306816fb57cf94f108a43c95731b08934dcae15c"; name = "JOPTSIMPLE_4_6_${sha1}/joptsimple-4-6.jar";                                       url = mirror://maven/net/sf/jopt-simple/jopt-simple/4.6/jopt-simple-4.6.jar; }
    rec { sha1 = "9cd14a61d7aa7d554f251ef285a6f2c65caf7b65"; name = "JOPTSIMPLE_4_6_${sha1}/joptsimple-4-6.sources.jar";                               url = mirror://maven/net/sf/jopt-simple/jopt-simple/4.6/jopt-simple-4.6-sources.jar; }
    rec { sha1 = "b852fb028de645ad2852bbe998e084d253f450a5"; name = "JMH_GENERATOR_ANNPROCESS_1_18_${sha1}/jmh-generator-annprocess-1-18.jar";         url = mirror://maven/org/openjdk/jmh/jmh-generator-annprocess/1.18/jmh-generator-annprocess-1.18.jar; }
    rec { sha1 = "d455b0dc6108b5e6f1fb4f6cf1c7b4cbedbecc97"; name = "JMH_GENERATOR_ANNPROCESS_1_18_${sha1}/jmh-generator-annprocess-1-18.sources.jar"; url = mirror://maven/org/openjdk/jmh/jmh-generator-annprocess/1.18/jmh-generator-annprocess-1.18-sources.jar; }
    rec { sha1 = "7aac374614a8a76cad16b91f1a4419d31a7dcda3"; name = "JMH_GENERATOR_ANNPROCESS_1_21_${sha1}/jmh-generator-annprocess-1-21.jar";         url = mirror://maven/org/openjdk/jmh/jmh-generator-annprocess/1.21/jmh-generator-annprocess-1.21.jar; }
    rec { sha1 = "fb48e2a97df95f8b9dced54a1a37749d2a64d2ae"; name = "JMH_GENERATOR_ANNPROCESS_1_21_${sha1}/jmh-generator-annprocess-1-21.sources.jar"; url = mirror://maven/org/openjdk/jmh/jmh-generator-annprocess/1.21/jmh-generator-annprocess-1.21-sources.jar; }
    rec { sha1 = "702b8525fcf81454235e5e2fa2a35f15ffc0ec7e"; name = "ASM_DEBUG_ALL_${sha1}/asm-debug-all.jar";                                         url = mirror://maven/org/ow2/asm/asm-debug-all/5.0.4/asm-debug-all-5.0.4.jar; }
    rec { sha1 = "ec2544ab27e110d2d431bdad7d538ed509b21e62"; name = "COMMONS_MATH3_3_2_${sha1}/commons-math3-3-2.jar";                                 url = mirror://maven/org/apache/commons/commons-math3/3.2/commons-math3-3.2.jar; }
    rec { sha1 = "cd098e055bf192a60c81d81893893e6e31a6482f"; name = "COMMONS_MATH3_3_2_${sha1}/commons-math3-3-2.sources.jar";                         url = mirror://maven/org/apache/commons/commons-math3/3.2/commons-math3-3.2-sources.jar; }
    rec { sha1 = "0174aa0077e9db596e53d7f9ec37556d9392d5a6"; name = "JMH_1_18_${sha1}/jmh-1-18.jar";                                                   url = mirror://maven/org/openjdk/jmh/jmh-core/1.18/jmh-core-1.18.jar; }
    rec { sha1 = "7ff1e1aafea436b6aa8b29a8b8f1c2d66be26f5b"; name = "JMH_1_18_${sha1}/jmh-1-18.sources.jar";                                           url = mirror://maven/org/openjdk/jmh/jmh-core/1.18/jmh-core-1.18-sources.jar; }
    rec { sha1 = "442447101f63074c61063858033fbfde8a076873"; name = "JMH_1_21_${sha1}/jmh-1-21.jar";                                                   url = mirror://maven/org/openjdk/jmh/jmh-core/1.21/jmh-core-1.21.jar; }
    rec { sha1 = "a6fe84788bf8cf762b0e561bf48774c2ea74e370"; name = "JMH_1_21_${sha1}/jmh-1-21.sources.jar";                                           url = mirror://maven/org/openjdk/jmh/jmh-core/1.21/jmh-core-1.21-sources.jar; }
    rec { sha1 = "2973d150c0dc1fefe998f834810d68f278ea58ec"; name = "JUNIT_${sha1}/junit.jar";                                                         url = mirror://maven/junit/junit/4.12/junit-4.12.jar; }
    rec { sha1 = "a6c32b40bf3d76eca54e3c601e5d1470c86fcdfa"; name = "JUNIT_${sha1}/junit.sources.jar";                                                 url = mirror://maven/junit/junit/4.12/junit-4.12-sources.jar; }
    rec { sha1 = "42a25dc3219429f0e5d060061f71acb49bf010a0"; name = "HAMCREST_${sha1}/hamcrest.jar";                                                   url = mirror://maven/org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.jar; }
    rec { sha1 = "1dc37250fbc78e23a65a67fbbaf71d2e9cbc3c0b"; name = "HAMCREST_${sha1}/hamcrest.sources.jar";                                           url = mirror://maven/org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3-sources.jar; }
    rec { sha1 = "0d031013db9a80d6c88330c42c983fbfa7053193"; name = "jvmci/intel-hsdis-amd64-linux-${sha1}.so";                                        url = "https://lafo.ssw.uni-linz.ac.at/pub/hsdis/intel/hsdis-amd64-linux-${sha1}.so"; }
  ];

  graal-mxcache = jvmci8-mxcache ++ [
    rec { sha1 = "f2cfb09cee12469ff64f0d698b13de19903bb4f7"; name = "NanoHTTPD-WebSocket_${sha1}/nanohttpd-websocket.jar";                             url = mirror://maven/org/nanohttpd/nanohttpd-websocket/2.3.1/nanohttpd-websocket-2.3.1.jar; }
    rec { sha1 = "a8d54d1ca554a77f377eff6bf9e16ca8383c8f6c"; name = "NanoHTTPD_${sha1}/nanohttpd.jar";                                                 url = mirror://maven/org/nanohttpd/nanohttpd/2.3.1/nanohttpd-2.3.1.jar; }
    rec { sha1 = "30b13b7efc55b7feea667691509cf59902375001"; name = "ANTLR4_${sha1}/antlr4.jar";                                                       url = mirror://maven/org/antlr/antlr4-runtime/4.7/antlr4-runtime-4.7.jar; }
    rec { sha1 = "fdedd5f2522122102f0b3db85fe7aa563a009926"; name = "JLINE_${sha1}/jline.jar";                                                         url = mirror://maven/jline/jline/2.14.5/jline-2.14.5.jar; }
    rec { sha1 = "d0bdc21c5e6404726b102998e44c66a738897905"; name = "JAVA_ALLOCATION_INSTRUMENTER_${sha1}/java-allocation-instrumenter.jar";           url = mirror://maven/com/google/code/java-allocation-instrumenter/java-allocation-instrumenter/3.1.0/java-allocation-instrumenter-3.1.0.jar; }
    rec { sha1 = "0da08b8cce7bbf903602a25a3a163ae252435795"; name = "ASM5_${sha1}/asm5.jar";                                                           url = mirror://maven/org/ow2/asm/asm/5.0.4/asm-5.0.4.jar; }
    rec { sha1 = "396ce0c07ba2b481f25a70195c7c94922f0d1b0b"; name = "ASM_TREE5_${sha1}/asm-tree5.jar";                                                 url = mirror://maven/org/ow2/asm/asm-tree/5.0.4/asm-tree-5.0.4.jar; }
    rec { sha1 = "280c265b789e041c02e5c97815793dfc283fb1e6"; name = "LIBFFI_${sha1}/libffi.tar.gz";                                                    url = https://lafo.ssw.uni-linz.ac.at/pub/graal-external-deps/libffi-3.2.1.tar.gz; }
    rec { sha1 = "8819cea8bfe22c9c63f55465e296b3855ea41786"; name = "TruffleJSON_${sha1}/trufflejson.jar";                                             url = https://lafo.ssw.uni-linz.ac.at/pub/graal-external-deps/trufflejson-20180130.jar; }
    rec { sha1 = "9712a8124c40298015f04a74f61b3d81a51513af"; name = "CHECKSTYLE_8.8_${sha1}/checkstyle-8.8.jar";                                       url = https://lafo.ssw.uni-linz.ac.at/pub/graal-external-deps/checkstyle-8.8-all.jar; }
    rec { sha1 = "a828a4f32caf9ac0b74f2548f87310959558c526"; name = "VISUALVM_COMMON_${sha1}/visualvm-common.tar.gz";                                  url = https://lafo.ssw.uni-linz.ac.at/pub/graal-external-deps/visualvm-612.tar.gz; }
    rec { sha1 = "7ac829f0c9a37f5cc39afd2265588a365480720d"; name = "VISUALVM_PLATFORM_SPECIFIC_${sha1}/visualvm-platform-specific.tar.gz";            url = https://lafo.ssw.uni-linz.ac.at/pub/graal-external-deps/visualvm-612-linux-amd64.tar.gz; }
    rec { sha1 = "e6e60889b7211a80b21052a249bd7e0f88f79fee"; name = "Java-WebSocket_${sha1}/java-websocket.jar";                                       url = mirror://maven/org/java-websocket/Java-WebSocket/1.3.9/Java-WebSocket-1.3.9.jar; }
  ];

  findbugs = fetchzip {
    name   = "findbugs-3.0.0";
    url    = https://lafo.ssw.uni-linz.ac.at/pub/graal-external-deps/findbugs-3.0.0.zip;
    sha256 = "0sf5f9h1s6fmhfigjy81i109j1ani5kzdr4njlpq0mnkkh9fpr7m";
  };

in rec {

  mx = stdenv.mkDerivation rec {
    version = "5.192.0";
    pname = "mx";
    src = fetchFromGitHub {
      owner  = "graalvm";
      repo   = "mx";
      rev    = version;
      sha256 = "04gdf1gzlc8a6li8lcnrs2j9zicj11fs1vqqf7cmhb4pm2h72hml";
    };
    nativeBuildInputs = [ makeWrapper ];
    buildPhase = ''
      substituteInPlace mx --replace /bin/pwd pwd

      # forbid network access while simulate success for passing obligatory "VerifyLibraryURL"
      substituteInPlace mx.py --replace \
        'def download(path, urls, verbose=False, abortOnError=True, verifyOnly=False):' \
        'def download(path, urls, verbose=False, abortOnError=True, verifyOnly=False):
          print("FAKE download(path={} urls={} verbose={} abortOnError={} verifyOnly={})".format(path, urls, verbose, abortOnError, verifyOnly))
          return True'

      # avoid crash with 'ValueError: ZIP does not support timestamps before 1980'
      substituteInPlace mx.py --replace \
        'zipfile.ZipInfo(arcname, time.localtime(os.path.getmtime(join(root, f)))[:6])' \
        'zipfile.ZipInfo(arcname, time.strptime ("1 Jan 1980", "%d %b %Y"       )[:6])'
    '';
    installPhase = ''
      mkdir -p $out/bin
      cp -dpR * $out/bin
      wrapProgram $out/bin/mx \
        --prefix PATH : ${lib.makeBinPath [ python27 mercurial ]} \
        --set    FINDBUGS_HOME ${findbugs}
    '';
    meta = with stdenv.lib; {
      homepage = https://github.com/graalvm/mx;
      description = "Command-line tool used for the development of Graal projects";
      license = licenses.unfree;
      platforms = python27.meta.platforms;
    };
  };

  # copy of pkgs.oraclejvm8 with JVMCI interface (TODO: it should work with pkgs.openjdk8 too)
  jvmci8 = stdenv.mkDerivation rec {
    version = "0.49";
    name = let
             n = "jvmci${/*"8u191"*/ lib.removePrefix "oraclejdk-" oraclejdk8.name}-${version}";
           in if (lib.stringLength n) == (lib.stringLength oraclejdk8.name) then
                n
              else
                throw "length of string `${n}' must be equal to the length of `${oraclejdk8.name}'";
    src = fetchFromGitHub {
      owner  = "graalvm";
      repo   = "graal-jvmci-8";
      rev    = "jvmci-${version}";
      sha256 = "1zgin0w1qa7wmfhcisx470fhnmddfxxp5nyyix31yaa7dznql82k";
    };
    buildInputs = [ mx mercurial ];
    postUnpack = ''
      # a fake mercurial dir to prevent mx crash and supply the version to mx
      ( cd $sourceRoot
        hg init
        hg add
        hg commit -m 'dummy commit'
        hg tag      ${lib.escapeShellArg src.rev}
        hg checkout ${lib.escapeShellArg src.rev}
      )
    '';
    hardeningDisable = [ "fortify" ];
    NIX_CFLAGS_COMPILE = [
      "-Wno-error=format-overflow" # newly detected by gcc7
      "-Wno-error=nonnull"
    ];
    buildPhase = ''
      cp -dpR ${oraclejdk8} writable-copy-of-jdk
      chmod +w -R writable-copy-of-jdk

      export MX_ALT_OUTPUT_ROOT=$NIX_BUILD_TOP/mxbuild
      export MX_CACHE_DIR=${makeMxCache jvmci8-mxcache}
      mx --java-home $(pwd)/writable-copy-of-jdk build
    '';
    installPhase = ''
      mv jdk1.8.0_*/linux-amd64/product $out
      find $out -type f -exec sed -i "s#${oraclejdk8}#$out#g" {} \;

      install -v -m0555 -D $MX_CACHE_DIR/jvmci/*hsdis*.so $out/jre/lib/amd64/hsdis-amd64.so
    '';
    dontFixup = true; # do not nuke path of ffmpeg etc
    dontStrip = true; # why? see in oraclejdk derivation
    inherit (oraclejdk8) meta;
  };

  graalvm8 = stdenv.mkDerivation rec {
    version = "1.0.0-rc8";
    name = let
             n = "graal-${version}";
           in if (lib.stringLength n) == (lib.stringLength jvmci8.name) then
                n
              else
                throw "length of string `${n}' must be equal to the length of `${jvmci8.name}'";
    src = fetchFromGitHub {
      owner  = "oracle";
      repo   = "graal";
      rev    = "vm-${version}";
      sha256 = "1fada4awrr8bhw294xdiq4bagvgrlcr44mw6338gaal0ky3vkm0p";
    };
    buildInputs = [ mx zlib mercurial jvmci8 ];
    postUnpack = ''
      # a fake mercurial dir to prevent mx crash and supply the version to mx
      ( cd $sourceRoot
        hg init
        hg add
        hg commit -m 'dummy commit'
        hg tag      ${lib.escapeShellArg src.rev}
        hg checkout ${lib.escapeShellArg src.rev}
      )
    '';
    postPatch = ''
      substituteInPlace substratevm/src/com.oracle.svm.core.posix/src/com/oracle/svm/core/posix/headers/PosixDirectives.java \
        --replace '<zlib.h>' '<${zlib.dev}/include/zlib.h>'
      substituteInPlace substratevm/src/com.oracle.svm.hosted/src/com/oracle/svm/hosted/image/CCLinkerInvocation.java \
        --replace 'cmd.add("-v");' 'cmd.add("-v"); cmd.add("-L${zlib}/lib");'
      substituteInPlace substratevm/src/com.oracle.svm.hosted/src/com/oracle/svm/hosted/c/codegen/CCompilerInvoker.java \
        --replace 'command.add(Platform.includedIn(Platform.WINDOWS.class) ? "CL" : "gcc");' \
          'command.add(Platform.includedIn(Platform.WINDOWS.class) ? "CL" : "${stdenv.cc}/bin/gcc");'
      substituteInPlace substratevm/src/com.oracle.svm.hosted/src/com/oracle/svm/hosted/image/CCLinkerInvocation.java \
        --replace 'protected String compilerCommand = "cc";' 'protected String compilerCommand = "${stdenv.cc}/bin/cc";'
    '';
    buildPhase = ''
      # make a copy of jvmci8
      cp -dpR ${jvmci8} $out
      chmod +w -R $out
      find $out -type f -exec sed -i "s#${jvmci8}#$out#g" {} \;

      export MX_ALT_OUTPUT_ROOT=$NIX_BUILD_TOP/mxbuild
      export MX_CACHE_DIR=${makeMxCache graal-mxcache}

      ( cd substratevm

        mkdir -p clibraries
        mx --java-home $out build

        # bootstrap native-image (that was removed from mx build in https://github.com/oracle/graal/commit/140d7a7edf54ec5872a8ff45869cd1ae499efde4)
        mx --java-home $out native-image -cp $MX_ALT_OUTPUT_ROOT/substratevm/dists/jdk1.8/svm-driver.jar com.oracle.svm.driver.NativeImage
      )
      ( cd tools
        mx --java-home $out build
      )
    '';
    installPhase = ''
      # add graal files modelling after directory structure of "graalvm-ce" binary distribution
      mkdir -p $out/jre/tools/{profiler,chromeinspector,truffle/builder} $out/jre/lib/{graal,include,truffle/include}
      cp -vpLR substratevm/svmbuild/native-image-root/lib/*                         $out/jre/lib/           || true # ignore "same file" error when dereferencing symlinks
      cp -vp   $MX_ALT_OUTPUT_ROOT/truffle/linux-amd64/truffle-nfi-native/bin/*     $out/jre/lib/amd64/
      cp -vp   $MX_ALT_OUTPUT_ROOT/compiler/dists/jdk1.8/graal-*processor*.jar      $out/jre/lib/graal/
      cp -vp   $MX_ALT_OUTPUT_ROOT/truffle/linux-amd64/truffle-nfi-native/include/* $out/jre/lib/include/
      cp -vp   $MX_ALT_OUTPUT_ROOT/compiler/dists/jdk1.8/graal-management.jar       $out/jre/lib/jvmci/
      cp -vdpR $out/jre/lib/svm/clibraries                                          $out/jre/lib/svm/builder/
      cp -vpR  $MX_ALT_OUTPUT_ROOT/truffle/dists/jdk1.8/*                           $out/jre/lib/truffle/
      cp -vp   $MX_ALT_OUTPUT_ROOT/truffle/linux-amd64/truffle-nfi-native/include/* $out/jre/lib/truffle/include/
      cp -vpLR substratevm/svmbuild/native-image-root/tools/*                       $out/jre/tools/
      cp -vpR  $MX_ALT_OUTPUT_ROOT/tools/dists/chromeinspector*                     $out/jre/tools/chromeinspector/
      cp -vpR  $MX_ALT_OUTPUT_ROOT/tools/dists/truffle-profiler*                    $out/jre/tools/profiler/
      cp -vpR  $MX_ALT_OUTPUT_ROOT/truffle/linux-amd64/truffle-nfi-native/*         $out/jre/tools/truffle/
      cp -vp   $MX_ALT_OUTPUT_ROOT/truffle/dists/jdk1.8/truffle-nfi.jar             $out/jre/tools/truffle/builder/

      echo "name=GraalVM ${version}"                                              > $out/jre/lib/amd64/server/vm.properties
      echo -n "graal"                                                             > $out/jre/lib/jvmci/compiler-name
      echo -n "../truffle/truffle-api.jar:../truffle/truffle-nfi.jar"             > $out/jre/lib/jvmci/parentClassLoader.classpath

      install -v -m0555 -D substratevm/com.oracle.svm.driver.nativeimage            $out/jre/lib/svm/bin/native-image
      ln -s                ../lib/svm/bin/native-image                              $out/jre/bin/native-image
      ln -s                ../jre/bin/native-image                                  $out/bin/native-image

      # BUG workaround http://mail.openjdk.java.net/pipermail/graal-dev/2017-December/005141.html
      substituteInPlace $out/jre/lib/security/java.security \
        --replace file:/dev/random    file:/dev/./urandom \
        --replace NativePRNGBlocking  SHA1PRNG
    '';
    dontFixup = true; # do not nuke path of ffmpeg etc
    dontStrip = true; # why? see in oraclejdk derivation
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
    '';

    passthru.home = graalvm8;

    meta = with stdenv.lib; {
      homepage = https://github.com/oracle/graal;
      description = "High-Performance Polyglot VM";
      license = licenses.unfree;
      maintainers = with maintainers; [ volth ];
      platforms = [ "x86_64-linux" ];
    };
  };
}
