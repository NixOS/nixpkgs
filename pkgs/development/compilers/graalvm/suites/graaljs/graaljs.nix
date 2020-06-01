{ stdenv
, glibc
, ant
, lib
, bzip2
, graalvm
, sdkVersion
, mx
, fetchFromGitHub
, fetchMavenArtifact
, fetchurl
}:

let
 mavenDeps = {
  icu4j = (fetchMavenArtifact {
    version = "66.1";
    artifactId = "icu4j";
    groupId = "com.ibm.icu";
    sha256 = "06hgh1ndj7gfnh60bknglbcv32g1nx4qsjagfxbw7mkzys9skk2x";
  });
  asm = (fetchMavenArtifact {
    version = "7.1";
    artifactId = "asm";
    groupId = "org.ow2.asm";
    sha256 = "1pnlb1ick32bihpzc599xl9ppd07qhls6pm0xaqwrj9cdlmzmcja";
  });
  asm-tree = (fetchMavenArtifact {
    version = "7.1";
    artifactId = "asm-tree";
    groupId = "org.ow2.asm";
    sha256 = "0wq0n7py73ylp59305wbnp3rc1jklacqr9d2ghfcflha1ci2ps60";
  });
  asm-analysis = (fetchMavenArtifact {
    version = "7.1";
    artifactId = "asm-analysis";
    groupId = "org.ow2.asm";
    sha256 = "0p5534jni1fb8nlls4g40fvqxv8rksax2yphf0jjmnv3398w04j6";
  });
  asm-commons = (fetchMavenArtifact {
    version = "7.1";
    artifactId = "asm-commons";
    groupId = "org.ow2.asm";
    sha256 = "0n6kxicikl5v1r5fqj4xw25c4nac6wbkpggapy2lv67iv24h8ng5";
  });
  asm-util = (fetchMavenArtifact {
    version = "7.1";
    artifactId = "asm-util";
    groupId = "org.ow2.asm";
    sha256 = "06jdqxhgbb6abilnliyl4mf1x1ia9829qcpjvh1i1blnfm8qai52";
  });
  jackson-core = (fetchMavenArtifact {
    version = "2.8.6";
    artifactId = "jackson-core";
    groupId = "com.fasterxml.jackson.core";
    sha256 = "17yal2yvq274ck65hrcj6ghc1dh47zcb7s14xzlxxak6vh3xda0h";
  });
  jackson-annotations = (fetchMavenArtifact {
    version = "2.8.6";
    artifactId = "jackson-annotations";
    groupId = "com.fasterxml.jackson.core";
    sha256 = "1y3kwzdg1kl6aj4rmaglyygfnsijzbd6mihmw2ivsx0i6q7mimwj";
  });
  jackson-databind = (fetchMavenArtifact {
    version = "2.8.6";
    artifactId = "jackson-databind";
    groupId = "com.fasterxml.jackson.core";
    sha256 = "18xs9fn8mpvkg4p223ghdzn254r10bzyiaifdbwg3a7m5z51694j";
  });
};

in stdenv.mkDerivation rec {
  version = sdkVersion;
  pname = "graaljs";
  src = fetchFromGitHub {
    owner = "graalvm";
    repo = "graaljs";
    rev = "vm-${version}";
    sha256 = "1zzp1dg0g4p5gfns17hxn9dkmmxdr33ifyjqw6pxbjy8lhsjsigp";
  };

  mavenDepsCp = builtins.concatStringsSep ":" (builtins.map (p: p.jar or p) (builtins.attrValues mavenDeps));

  buildInputs = [
    graalvm ant mx
  ];

  patches = [];

  buildPhase = ''
    export CLASSPATH=''${CLASSPATH-}:${builtins.concatStringsSep ":" [
      "${graalvm}/jre/lib/graal/graal-compiler-match-processor.jar"
      "${graalvm}/jre/lib/graal/graal-nodeinfo-processor.jar"
      "${graalvm}/jre/lib/graal/graal-options-processor.jar"
      "${graalvm}/jre/lib/graal/graal-processor-common.jar"
      "${graalvm}/jre/lib/graal/graal-replacements-processor.jar"
      "${graalvm}/jre/lib/graal/graal-serviceprovider-processor.jar"
      "${graalvm}/jre/lib/graalvm/launcher-common.jar"
      "${graalvm}/jre/lib/truffle/locator.jar"
      "${graalvm}/jre/lib/truffle/truffle-api.jar"
      "${graalvm}/jre/lib/truffle/truffle-dsl-processor.jar"
      "${graalvm}/jre/lib/truffle/truffle-tck.jar"
      "${graalvm}/jre/languages/regex/tregex.jar"
      "${graalvm}/jre/lib/boot/graal-sdk.jar"
      "${graalvm}/jre/lib/ext/nashorn.jar"
      mavenDepsCp
    ]}

    ## GRAAL-JS ##

    cp ${ ./build-js.xml } build.xml
    ant js-launcher
    ant js-factory
    ant js-scriptengine
    ant js-graaljs
    ant truffle-js-jdk8
    ant truffle-js-snapshot-tool

    mkdir -p $out/jre/languages/js
    mkdir -p $out/jre/lib/boot
    cp ${mavenDeps.asm-analysis.jar} $out/jre/languages/js/asm-analysis.jar
    cp ${mavenDeps.asm-commons.jar} $out/jre/languages/js/asm-commons.jar
    cp ${mavenDeps.asm-tree.jar} $out/jre/languages/js/asm-tree.jar
    cp ${mavenDeps.asm-util.jar} $out/jre/languages/js/asm-util.jar
    cp ${mavenDeps.asm.jar} $out/jre/languages/js/asm.jar
    cp ${mavenDeps.icu4j.jar} $out/jre/languages/js/icu4j.jar
    cp target/jar/graaljs-launcher.jar $out/jre/languages/js
    cp target/jar/graaljs.jar $out/jre/languages/js
    cp target/jar/graaljs-scriptengine.jar $out/jre/lib/boot
    cp target/jar/truffle-js-snapshot-tool.jar $out/jre/languages/js
    cp target/jar/truffle-js-jdk*.jar $out/jre/languages/js
    cp src/com.oracle.truffle.js/src/com/oracle/truffle/js/runtime/resources/*.json \
      $out/jre/languages/js

    export TRUFFLE_JARS=${builtins.concatStringsSep ":" [
      "$out/jre/languages/js/graaljs.jar"
      "$out/jre/languages/js/graaljs-launcher.jar"
      "$out/jre/languages/js/asm-analysis.jar"
      "$out/jre/languages/js/asm-commons.jar"
      "$out/jre/languages/js/asm-tree.jar"
      "$out/jre/languages/js/asm-util.jar"
      "$out/jre/languages/js/asm.jar"
      "$out/jre/languages/js/icu4j.jar"
    ]}

   export IMAGE_CLASSPATH=''${TRUFFLE_JARS-}:${builtins.concatStringsSep ":" [
     "${graalvm}/jre/languages/regex/tregex.jar"
     "${graalvm}/jre/lib/graalvm/launcher-common.jar"
     "${graalvm}/jre/lib/graal/graal-compiler-match-processor.jar"
     "${graalvm}/jre/lib/graal/graal-nodeinfo-processor.jar"
     "${graalvm}/jre/lib/graal/graal-options-processor.jar"
     "${graalvm}/jre/lib/graal/graal-processor-common.jar"
     "${graalvm}/jre/lib/graal/graal-replacements-processor.jar"
     "${graalvm}/jre/lib/graal/graal-serviceprovider-processor.jar"
     "${graalvm}/jre/lib/truffle/locator.jar"
     "${graalvm}/jre/lib/truffle/truffle-api.jar"
     "${graalvm}/jre/lib/truffle/truffle-dsl-processor.jar"
     "${graalvm}/jre/lib/boot/graal-sdk.jar"
     "${graalvm}/jre/lib/ext/nashorn.jar"
   ]}

    native-image -cp $out/jre/languages/js:$IMAGE_CLASSPATH \
      -J-Xmx3G -H:MaxRuntimeCompileMethods=9000 \
      -Djvmci.class.path.append=$out/jre/lib/boot/graaljs-scriptengine.jar \
      -Djvmci.class.path.append=${graalvm}/jre/lib/boot/graal-sdk.jar \
      -Dtruffle.class.path.append=$out/jre/lib/boot/graaljs-scriptengine.jar \
      -Dtruffle.class.path.append=$out/jre/languages/js/graaljs.jar \
      -Dtruffle.class.path.append=$out/jre/languages/js/graaljs-launcher.jar \
      -Dtruffle.class.path.append=$out/jre/languages/js/icu4j.jar \
      -Dtruffle.class.path.append=$out/jre/languages/js/asm.jar \
      -Dtruffle.class.path.append=$out/jre/languages/js/asm-analysis.jar \
      -Dtruffle.class.path.append=$out/jre/languages/js/asm-commons.jar \
      -Dtruffle.class.path.append=$out/jre/languages/js/asm-util.jar \
      -Dtruffle.class.path.append=$out/jre/languages/js/asm-tree.jar \
      -Dpolyglot.image-build-time.PreinitializeContexts=js \
      --language:regex -H:+AddAllCharsets \
      -H:IncludeResourceBundles=jline.console.completer.CandidateListCompletionHandler \
      -H:Path=$out/jre/languages/js \
      -H:ReflectionConfigurationResources=./reflect-config.json \
      -H:ResourceConfigurationResources=./resource-config.json \
      --initialize-at-build-time=com.oracle.truffle.js,com.oracle.js.parser,com.oracle.truffle.trufflenode,com.oracle.truffle.regex \
      --initialize-at-run-time=com.ibm.icu,com.oracle.js.parser.ECMAErrors \
      com.oracle.truffle.js.shell.JSLauncher \
      $out/jre/languages/js/bin/js
  '';

  installPhase = ''
    mkdir -p $out/bin
    ln -s $out/jre/languages/js/bin/js $out/bin/js
    # {builtins.concatStringsSep ";" (builtins.map (x: "cp -rf {x.jar} $out/jre/languages/js/{x.name}.jar") mavenDeps)}
  '';

  dontStrip = true;
}
