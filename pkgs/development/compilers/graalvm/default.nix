{ stdenv, lib, fetchFromGitHub, fetchhg, fetchurl, mercurial, python27, zlib, makeWrapper, oraclejdk8 }:

let
  # pre-download some cache entries ('mx' will not be able to download under nixbld1)
  makeMxCache = list:
    stdenv.mkDerivation {
      name = "mx-cache";
      buildCommand = ''
        mkdir $out
        ${lib.concatMapStrings ({url, name, sha1}: ''
                                  ln -s ${fetchurl { inherit url sha1; }} $out/${name}
                                  echo -n ${sha1} > $out/${name}.sha1
                                '') list}
      '';
    };

  jvmci8-mxcache = [
    rec { sha1 = "66215826a684eb6866d4c14a5a4f9c344f1d1eef"; name = "JACOCOCORE_${sha1}.jar";                            url = mirror://maven/org/jacoco/org.jacoco.core/0.7.9/org.jacoco.core-0.7.9.jar; }
    rec { sha1 = "a365ee459836b2aa18028929923923d15f0c3af9"; name = "JACOCOCORE.sources_${sha1}.jar";                    url = mirror://maven/org/jacoco/org.jacoco.core/0.7.9/org.jacoco.core-0.7.9-sources.jar; }
    rec { sha1 = "8a7f78fdf2a4e58762890d8e896a9298c2980c10"; name = "JACOCOREPORT_${sha1}.jar";                          url = mirror://maven/org/jacoco/org.jacoco.report/0.7.9/org.jacoco.report-0.7.9.jar; }
    rec { sha1 = "e6703ef288523a8e63fa756d8adeaa70858d41b0"; name = "JACOCOREPORT.sources_${sha1}.jar";                  url = mirror://maven/org/jacoco/org.jacoco.report/0.7.9/org.jacoco.report-0.7.9-sources.jar; }
    rec { sha1 = "306816fb57cf94f108a43c95731b08934dcae15c"; name = "JOPTSIMPLE_4_6_${sha1}.jar";                        url = mirror://maven/net/sf/jopt-simple/jopt-simple/4.6/jopt-simple-4.6.jar; }
    rec { sha1 = "9cd14a61d7aa7d554f251ef285a6f2c65caf7b65"; name = "JOPTSIMPLE_4_6.sources_${sha1}.jar";                url = mirror://maven/net/sf/jopt-simple/jopt-simple/4.6/jopt-simple-4.6-sources.jar; }
    rec { sha1 = "b852fb028de645ad2852bbe998e084d253f450a5"; name = "JMH_GENERATOR_ANNPROCESS_1_18_${sha1}.jar";         url = mirror://maven/org/openjdk/jmh/jmh-generator-annprocess/1.18/jmh-generator-annprocess-1.18.jar; }
    rec { sha1 = "d455b0dc6108b5e6f1fb4f6cf1c7b4cbedbecc97"; name = "JMH_GENERATOR_ANNPROCESS_1_18.sources_${sha1}.jar"; url = mirror://maven/org/openjdk/jmh/jmh-generator-annprocess/1.18/jmh-generator-annprocess-1.18-sources.jar; }
    rec { sha1 = "702b8525fcf81454235e5e2fa2a35f15ffc0ec7e"; name = "ASM_DEBUG_ALL_${sha1}.jar";                         url = mirror://maven/org/ow2/asm/asm-debug-all/5.0.4/asm-debug-all-5.0.4.jar; }
    rec { sha1 = "ec2544ab27e110d2d431bdad7d538ed509b21e62"; name = "COMMONS_MATH3_3_2_${sha1}.jar";                     url = mirror://maven/org/apache/commons/commons-math3/3.2/commons-math3-3.2.jar; }
    rec { sha1 = "cd098e055bf192a60c81d81893893e6e31a6482f"; name = "COMMONS_MATH3_3_2.sources_${sha1}.jar";             url = mirror://maven/org/apache/commons/commons-math3/3.2/commons-math3-3.2-sources.jar; }
    rec { sha1 = "0174aa0077e9db596e53d7f9ec37556d9392d5a6"; name = "JMH_1_18_${sha1}.jar";                              url = mirror://maven/org/openjdk/jmh/jmh-core/1.18/jmh-core-1.18.jar; }
    rec { sha1 = "7ff1e1aafea436b6aa8b29a8b8f1c2d66be26f5b"; name = "JMH_1_18.sources_${sha1}.jar";                      url = mirror://maven/org/openjdk/jmh/jmh-core/1.18/jmh-core-1.18-sources.jar; }
    rec { sha1 = "2973d150c0dc1fefe998f834810d68f278ea58ec"; name = "JUNIT_${sha1}.jar";                                 url = https://lafo.ssw.uni-linz.ac.at/pub/graal-external-deps/junit-4.12.jar; }
    rec { sha1 = "a6c32b40bf3d76eca54e3c601e5d1470c86fcdfa"; name = "JUNIT.sources_${sha1}.jar";                         url = https://lafo.ssw.uni-linz.ac.at/pub/graal-external-deps/junit-4.12-sources.jar; }
    rec { sha1 = "42a25dc3219429f0e5d060061f71acb49bf010a0"; name = "HAMCREST_${sha1}.jar";                              url = https://lafo.ssw.uni-linz.ac.at/pub/graal-external-deps/hamcrest-core-1.3.jar; }
    rec { sha1 = "1dc37250fbc78e23a65a67fbbaf71d2e9cbc3c0b"; name = "HAMCREST.sources_${sha1}.jar";                      url = https://lafo.ssw.uni-linz.ac.at/pub/graal-external-deps/hamcrest-core-1.3-sources.jar; }
    rec { sha1 = "0d031013db9a80d6c88330c42c983fbfa7053193"; name = "hsdis_${sha1}.so";                                  url = https://lafo.ssw.uni-linz.ac.at/pub/hsdis/intel/hsdis-amd64-linux-0d031013db9a80d6c88330c42c983fbfa7053193.so; }
  ];

  graal-mxcache = jvmci8-mxcache ++ [
    rec { sha1 = "f2cfb09cee12469ff64f0d698b13de19903bb4f7"; name = "NanoHTTPD-WebSocket_${sha1}.jar";                   url = mirror://maven/org/nanohttpd/nanohttpd-websocket/2.3.1/nanohttpd-websocket-2.3.1.jar; }
    rec { sha1 = "a8d54d1ca554a77f377eff6bf9e16ca8383c8f6c"; name = "NanoHTTPD_${sha1}.jar";                             url = mirror://maven/org/nanohttpd/nanohttpd/2.3.1/nanohttpd-2.3.1.jar; }
    rec { sha1 = "aca5eb39e2a12fddd6c472b240afe9ebea3a6733"; name = "org.json_${sha1}.jar";                              url = mirror://maven/org/json/json/20160810/json-20160810.jar; }
    rec { sha1 = "fdedd5f2522122102f0b3db85fe7aa563a009926"; name = "JLINE_${sha1}.jar";                                 url = mirror://maven/jline/jline/2.14.5/jline-2.14.5.jar; }
    rec { sha1 = "476d9a44cd19d6b55f81571077dfa972a4f8a083"; name = "JAVA_ALLOCATION_INSTRUMENTER_${sha1}.jar";          url = https://lafo.ssw.uni-linz.ac.at/pub/graal-external-deps/java-allocation-instrumenter/java-allocation-instrumenter-8f0db117e64e.jar; }
    rec { sha1 = "0da08b8cce7bbf903602a25a3a163ae252435795"; name = "ASM5_${sha1}.jar";                                  url = https://lafo.ssw.uni-linz.ac.at/pub/graal-external-deps/asm-5.0.4.jar; }
    rec { sha1 = "396ce0c07ba2b481f25a70195c7c94922f0d1b0b"; name = "ASM_TREE5_${sha1}.jar";                             url = https://lafo.ssw.uni-linz.ac.at/pub/graal-external-deps/asm-tree-5.0.4.jar; }
    rec { sha1 = "280c265b789e041c02e5c97815793dfc283fb1e6"; name = "LIBFFI_${sha1}.tar.gz";                             url = https://lafo.ssw.uni-linz.ac.at/pub/graal-external-deps/libffi-3.2.1.tar.gz; }
    rec { sha1 = "616a4fca49c5d610a3354e78cd97e7627024bb66"; name = "GSON_SHADOWED_${sha1}.jar";                         url = https://lafo.ssw.uni-linz.ac.at/pub/graal-external-deps/gson-shadowed-2.2.4.jar; }
    rec { sha1 = "b13337a4ffd095c2e27ea401dc6edfca0d23a6e4"; name = "GSON_SHADOWED.sources_${sha1}.jar";                 url = https://lafo.ssw.uni-linz.ac.at/pub/graal-external-deps/gson-shadowed-2.2.4-sources.jar; }
  ];

in rec {

  mx = stdenv.mkDerivation {
    name = "mx";
    src = fetchFromGitHub {
      owner  = "graalvm";
      repo   = "mx";
      rev    = "22557cf7ec417c49aca20c13a9123045005d72d0"; # HEAD at 2018-02-16
      sha256 = "070647ih2qzcssj7yripbg1w9bjwi1rcp1blx5z3jbp1shrr6563";
    };
    nativeBuildInputs = [ makeWrapper ];
    buildPhase = ''
      substituteInPlace mx --replace /bin/pwd pwd
    '';
    installPhase = ''
      mkdir -p $out/bin
      cp -dpR * $out/bin
      wrapProgram $out/bin/mx --prefix PATH : ${lib.makeBinPath [ python27 mercurial ]}
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
    version = "0.41";
    name = let
             n = "jvmci8u161-${version}";
           in if (lib.stringLength n) == (lib.stringLength oraclejdk8.name) then
                n
              else
                throw "length of string `${n}' must be equal to the length of `${oraclejdk8.name}'";
    src = fetchFromGitHub {
      owner  = "graalvm";
      repo   = "graal-jvmci-8";
      rev    = "jvmci-${version}";
      sha256 = "0pajf114l8lzczfdzz968c3s1ardiy4q5ya8p2kmwxl06giy95qr";
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
    NIX_CFLAGS_COMPILE = [
      "-Wno-error=format-overflow" # newly detected by gcc7
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
    '';
    dontStrip = true; # why? see in oraclejdk derivation
    inherit (oraclejdk8) meta;
  };

  graalvm8 = stdenv.mkDerivation rec {
    version = "0.31";
    name = let
             n = "graal-vm-8-${version}";
           in if (lib.stringLength n) == (lib.stringLength jvmci8.name) then
                n
              else
                throw "length of string `${n}' must be equal to the length of `${jvmci8.name}'";
    src = fetchFromGitHub {
      owner  = "oracle";
      repo   = "graal";
      rev    = "vm-enterprise-${version}";
      sha256 = "0rhd6dk2jpbxgdprqvdk991b2k177jrjgyjabdnmv5lzlhczy676";
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
    buildPhase = ''
      # make a copy of jvmci8
      cp -dpR ${jvmci8} $out
      chmod +w -R $out
      find $out -type f -exec sed -i "s#${jvmci8}#$out#g" {} \;

      export MX_ALT_OUTPUT_ROOT=$NIX_BUILD_TOP/mxbuild
      export MX_CACHE_DIR=${makeMxCache graal-mxcache}
      ( cd substratevm; mx --java-home $out build --no-daemon )
    '';
    installPhase = ''
      # add graal files
      mkdir -p $out/jre/tools/{profiler,chromeinspector}
      cp -pR  substratevm/svmbuild/native-image-root/linux-amd64/bin/*  $out/jre/bin/
      cp -pLR substratevm/svmbuild/native-image-root/lib/*              $out/jre/lib/           || true # ignore "same file" error when dereferencing symlinks
      cp -pLR substratevm/svmbuild/native-image-root/tools/*            $out/jre/tools/
      cp -pR  $MX_ALT_OUTPUT_ROOT/truffle/dists/*                       $out/jre/lib/truffle/
      cp -pR  $MX_ALT_OUTPUT_ROOT/tools/dists/truffle-profiler*         $out/jre/tools/profiler/
      cp -pR  $MX_ALT_OUTPUT_ROOT/tools/dists/chromeinspector*          $out/jre/tools/chromeinspector/
      echo "name=GraalVM ${version}"                                  > $out/jre/lib/amd64/server/vm.properties
      ln -s --relative $out/jre/bin/native-image                        $out/bin/native-image
      cp      $out/jre/tools/nfi/bin/libtrufflenfi.so                   $out/jre/lib/amd64/
      cp -dpR $out/jre/lib/svm/clibraries                               $out/jre/lib/svm/builder/

      # BUG workaround http://mail.openjdk.java.net/pipermail/graal-dev/2017-December/005141.html
      substituteInPlace $out/jre/lib/security/java.security \
        --replace file:/dev/random    file:/dev/./urandom \
        --replace NativePRNGBlocking  SHA1PRNG
    '';
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
      $out/bin/native-image -no-server HelloWorld
      ./helloworld
      ./helloworld | fgrep 'Hello World'
    '';
    meta = with stdenv.lib; {
      homepage = https://github.com/oracle/graal;
      description = "High-Performance Polyglot VM";
      license = licenses.unfree;
      maintainers = with maintainers; [ volth ];
      platforms = [ "x86_64-linux" ];
    };
  };
}
