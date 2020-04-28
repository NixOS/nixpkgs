{ stdenv
, lib
, fetchFromGitHub
, openjdk
, setJavaClassPath
, mx
, makeMxCache
, libobjc
, CoreFoundation
, Foundation
, JavaNativeFoundation
, JavaRuntimeSupport
, JavaVM
, xcodebuild
, Cocoa
}:
let
  jvmci8-mxcache = [
    rec {
      sha1 = "53addc878614171ff0fcbc8f78aed12175c22cdb";
      name = "JACOCOCORE_0.8.4_${sha1}/jacococore-0.8.4.jar";
      url = mirror://maven/org/jacoco/org.jacoco.core/0.8.4/org.jacoco.core-0.8.4.jar;
    }
    rec {
      sha1 = "9bd1fa334d941005bc9ab3ac92478a590f5b7d73";
      name = "JACOCOCORE_0.8.4_${sha1}/jacococore-0.8.4.sources.jar";
      url = mirror://maven/org/jacoco/org.jacoco.core/0.8.4/org.jacoco.core-0.8.4-sources.jar;
    }
    rec {
      sha1 = "e5ca9511493b7e3bc2cabdb8ded92e855f3aac32";
      name = "JACOCOREPORT_0.8.4_${sha1}/jacocoreport-0.8.4.jar";
      url = mirror://maven/org/jacoco/org.jacoco.report/0.8.4/org.jacoco.report-0.8.4.jar;
    }
    rec {
      sha1 = "eb61e479b35b467954f28a565c094c563b790e19";
      name = "JACOCOREPORT_0.8.4_${sha1}/jacocoreport-0.8.4.sources.jar";
      url = mirror://maven/org/jacoco/org.jacoco.report/0.8.4/org.jacoco.report-0.8.4-sources.jar;
    }
    rec {
      sha1 = "869021a6d90cfb008b12e83fccbe42eca29e5355";
      name = "JACOCOAGENT_0.8.4_${sha1}/jacocoagent-0.8.4.jar";
      url = mirror://maven/org/jacoco/org.jacoco.agent/0.8.4/org.jacoco.agent-0.8.4-runtime.jar;
    }
    rec {
      sha1 = "306816fb57cf94f108a43c95731b08934dcae15c";
      name = "JOPTSIMPLE_4_6_${sha1}/joptsimple-4-6.jar";
      url = mirror://maven/net/sf/jopt-simple/jopt-simple/4.6/jopt-simple-4.6.jar;
    }
    rec {
      sha1 = "9cd14a61d7aa7d554f251ef285a6f2c65caf7b65";
      name = "JOPTSIMPLE_4_6_${sha1}/joptsimple-4-6.sources.jar";
      url = mirror://maven/net/sf/jopt-simple/jopt-simple/4.6/jopt-simple-4.6-sources.jar;
    }
    rec {
      sha1 = "fa29aa438674ff19d5e1386d2c3527a0267f291e";
      name = "ASM_7.1_${sha1}/asm-7.1.jar";
      url = mirror://maven/org/ow2/asm/asm/7.1/asm-7.1.jar;
    }
    rec {
      sha1 = "9d170062d595240da35301362b079e5579c86f49";
      name = "ASM_7.1_${sha1}/asm-7.1.sources.jar";
      url = mirror://maven/org/ow2/asm/asm/7.1/asm-7.1-sources.jar;
    }
    rec {
      sha1 = "a3662cf1c1d592893ffe08727f78db35392fa302";
      name = "ASM_TREE_7.1_${sha1}/asm-tree-7.1.jar";
      url = mirror://maven/org/ow2/asm/asm-tree/7.1/asm-tree-7.1.jar;
    }
    rec {
      sha1 = "157238292b551de8680505fa2d19590d136e25b9";
      name = "ASM_TREE_7.1_${sha1}/asm-tree-7.1.sources.jar";
      url = mirror://maven/org/ow2/asm/asm-tree/7.1/asm-tree-7.1-sources.jar;
    }
    rec {
      sha1 = "379e0250f7a4a42c66c5e94e14d4c4491b3c2ed3";
      name = "ASM_ANALYSIS_7.1_${sha1}/asm-analysis-7.1.jar";
      url = mirror://maven/org/ow2/asm/asm-analysis/7.1/asm-analysis-7.1.jar;
    }
    rec {
      sha1 = "36789198124eb075f1a5efa18a0a7812fb16f47f";
      name = "ASM_ANALYSIS_7.1_${sha1}/asm-analysis-7.1.sources.jar";
      url = mirror://maven/org/ow2/asm/asm-analysis/7.1/asm-analysis-7.1-sources.jar;
    }
    rec {
      sha1 = "431dc677cf5c56660c1c9004870de1ed1ea7ce6c";
      name = "ASM_COMMONS_7.1_${sha1}/asm-commons-7.1.jar";
      url = mirror://maven/org/ow2/asm/asm-commons/7.1/asm-commons-7.1.jar;
    }
    rec {
      sha1 = "a62ff3ae6e37affda7c6fb7d63b89194c6d006ee";
      name = "ASM_COMMONS_7.1_${sha1}/asm-commons-7.1.sources.jar";
      url = mirror://maven/org/ow2/asm/asm-commons/7.1/asm-commons-7.1-sources.jar;
    }
    rec {
      sha1 = "ec2544ab27e110d2d431bdad7d538ed509b21e62";
      name = "COMMONS_MATH3_3_2_${sha1}/commons-math3-3-2.jar";
      url = mirror://maven/org/apache/commons/commons-math3/3.2/commons-math3-3.2.jar;
    }
    rec {
      sha1 = "cd098e055bf192a60c81d81893893e6e31a6482f";
      name = "COMMONS_MATH3_3_2_${sha1}/commons-math3-3-2.sources.jar";
      url = mirror://maven/org/apache/commons/commons-math3/3.2/commons-math3-3.2-sources.jar;
    }
    rec {
      sha1 = "442447101f63074c61063858033fbfde8a076873";
      name = "JMH_1_21_${sha1}/jmh-1-21.jar";
      url = mirror://maven/org/openjdk/jmh/jmh-core/1.21/jmh-core-1.21.jar;
    }
    rec {
      sha1 = "a6fe84788bf8cf762b0e561bf48774c2ea74e370";
      name = "JMH_1_21_${sha1}/jmh-1-21.sources.jar";
      url = mirror://maven/org/openjdk/jmh/jmh-core/1.21/jmh-core-1.21-sources.jar;
    }
    rec {
      sha1 = "7aac374614a8a76cad16b91f1a4419d31a7dcda3";
      name = "JMH_GENERATOR_ANNPROCESS_1_21_${sha1}/jmh-generator-annprocess-1-21.jar";
      url = mirror://maven/org/openjdk/jmh/jmh-generator-annprocess/1.21/jmh-generator-annprocess-1.21.jar;
    }
    rec {
      sha1 = "fb48e2a97df95f8b9dced54a1a37749d2a64d2ae";
      name = "JMH_GENERATOR_ANNPROCESS_1_21_${sha1}/jmh-generator-annprocess-1-21.sources.jar";
      url = mirror://maven/org/openjdk/jmh/jmh-generator-annprocess/1.21/jmh-generator-annprocess-1.21-sources.jar;
    }
    rec {
      sha1 = "2973d150c0dc1fefe998f834810d68f278ea58ec";
      name = "JUNIT_${sha1}/junit.jar";
      url = mirror://maven/junit/junit/4.12/junit-4.12.jar;
    }
    rec {
      sha1 = "a6c32b40bf3d76eca54e3c601e5d1470c86fcdfa";
      name = "JUNIT_${sha1}/junit.sources.jar";
      url = mirror://maven/junit/junit/4.12/junit-4.12-sources.jar;
    }
    rec {
      sha1 = "42a25dc3219429f0e5d060061f71acb49bf010a0";
      name = "HAMCREST_${sha1}/hamcrest.jar";
      url = mirror://maven/org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3.jar;
    }
    rec {
      sha1 = "1dc37250fbc78e23a65a67fbbaf71d2e9cbc3c0b";
      name = "HAMCREST_${sha1}/hamcrest.sources.jar";
      url = mirror://maven/org/hamcrest/hamcrest-core/1.3/hamcrest-core-1.3-sources.jar;
    }
    rec {
      sha1 = "e39a00f425f8fc41dde434686080a94e94884f30";
      name = "LIBF2C_${sha1}/libf2c.zip";
      url = https://netlib.sandia.gov/f2c/libf2c.zip;
    }
    rec {
      sha1 = "ckknshl23hhq5y2fsnmzf028gnlfmxvw";
      name = "F2C_${sha1}/f2c.tgz";
      url = https://netlib.sandia.gov/f2c/src.tgz;
    }
  ] ++ lib.optionals stdenv.isLinux [
    rec {
      sha1 = "0d031013db9a80d6c88330c42c983fbfa7053193";
      name = "hsdis_${sha1}/hsdis.so";
      url = "https://lafo.ssw.uni-linz.ac.at/pub/graal-external-deps/hsdis/intel/hsdis-amd64-linux-${sha1}.so";
    }
  ]
  ++ lib.optionals stdenv.isDarwin [
    rec {
      sha1 = "67f6d23cbebd8998450a88b5bef362171f66f11a";
      name = "hsdis_${sha1}/hsdis.dylib";
      url = "https://lafo.ssw.uni-linz.ac.at/pub/graal-external-deps/hsdis/intel/hsdis-amd64-darwin-${sha1}.dylib";
    }
  ];
in
stdenv.mkDerivation rec {
  version = "20.0-b03";
  pname = "jvmci";
  src = fetchFromGitHub {
    owner = "graalvm";
    repo = "graal-jvmci-8";
    rev = "jvmci-${version}";
    sha256 = "1isrdpjb0a7kfplz0ywfqc3alw18rgnjawgdrain723d955zbgfa";
  };
  buildInputs = [ mx openjdk ] ++ lib.optional stdenv.isDarwin [
    libobjc
    CoreFoundation
    Foundation
    JavaNativeFoundation
    JavaRuntimeSupport
    JavaVM
    xcodebuild
    Cocoa
  ];
  patches = [ ./mx_jvmci.py.patch ]
  ++ lib.optional stdenv.isDarwin [
    ./mx_jvmci_suite.patch
  ];
  postPatch = ''
    # The hotspot version name regex fix
    substituteInPlace mx.jvmci/mx_jvmci.py \
      --replace "\\d+.\\d+-b\\d+" "\\d+.\\d+-b[g\\d][a\\d]"
    # darwin: https://github.com/oracle/graal/issues/1816
    substituteInPlace src/share/vm/code/compiledIC.cpp \
      --replace 'entry == false' '*entry == false'
  '';
  hardeningDisable = [ "fortify" ];
  NIX_CFLAGS_COMPILE = toString (lib.optional stdenv.isDarwin [
    "-Wno-reserved-user-defined-literal"
    "-Wno-c++11-narrowing"
  ]
  ++ lib.optional stdenv.isLinux [
    "-Wno-error=format-overflow" # newly detected by gcc7
    "-Wno-error=nonnull"
  ]
  );

  buildPhase = ''
    export MX_ALT_OUTPUT_ROOT=$NIX_BUILD_TOP/mxbuild
    export MX_CACHE_DIR=$NIX_BUILD_TOP/mxcache
    export MX_NIX_OUTPUT_ROOT=$PWD
    ${makeMxCache { depList = jvmci8-mxcache; outputDir = "$MX_CACHE_DIR"; }}

    mx-internal --primary-suite . --vm=server build -DFULL_DEBUG_SYMBOLS=0
    mx-internal --primary-suite . --vm=server -v vm -version
    mx-internal --primary-suite . --vm=server -v unittest
  '';

  installPhase = ''
    mkdir -p $out
    ${if stdenv.isDarwin
      then "mv openjdk1.8.0_*/darwin-amd64/product/* $out"
      else "mv openjdk1.8.0_*/linux-amd64/product/* $out"}
    install -v -m0555 -D $MX_CACHE_DIR/hsdis*/hsdis.so $out/jre/lib/amd64/hsdis-amd64.so
    # https://github.com/graalvm/openjdk8-jvmci-builder/issues/11#issuecomment-566545056
    cp ${openjdk}/lib/*.a $out/jre/lib
  '';

  # copy-paste openjdk's preFixup
  preFixup = ''
    # Propagate the setJavaClassPath setup hook from the JRE so that
    # any package that depends on the JRE has $CLASSPATH set up
    # properly.
    mkdir -p $out/nix-support
    printWords ${setJavaClassPath} > $out/nix-support/propagated-build-inputs

    # Set JAVA_HOME automatically.
    mkdir -p $out/nix-support
    cat <<EOF > $out/nix-support/setup-hook
    if [ -z "\''${JAVA_HOME-}" ]; then export JAVA_HOME=$out; fi
    EOF
  '';
  postFixup = openjdk.postFixup or null;
  dontStrip = true; # stripped javac crashes with "segmentaion fault"
  inherit (openjdk) meta;
}
