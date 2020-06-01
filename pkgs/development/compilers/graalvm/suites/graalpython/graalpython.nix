{ stdenv
, glibc
, ant
, lib
, bzip2
, graalvm
, sdkVersion
, fetchFromGitHub
, fetchMavenArtifact
, fetchurl
, python38
}:

let mavenDeps = [
  (fetchurl {
    url = "https://lafo.ssw.uni-linz.ac.at/pub/graal-external-deps/antlr-4.7.2-complete.jar";
    sha256 = "1d40nfkq3ws8g4ksx4gj6l6m2l9j4b605q6sf68z5vvmg5nkhlk8";
  })
  (fetchMavenArtifact {
    version = "1.8";
    artifactId = "xz";
    groupId = "org.tukaani";
    sha256 = "0pgzi9afka6bl2zzbckxj60wx4g4hkzwnkxh8kkcpw73dyrn8ycc";
  })];

in stdenv.mkDerivation rec {
  version = sdkVersion;
  pname = "graalpython";
  src = fetchFromGitHub {
    owner = "graalvm";
    repo = "graalpython";
    rev = "vm-${version}";
    sha256 = "0g70zn2vq8j5lxq1zs5w1ndvsxd1jkydxpnjm82b1lvidi69pqrb";
  };

  mavenDepsCp = builtins.concatStringsSep ":" (builtins.map (p: p.jar or p) mavenDeps);

  buildInputs = [
    graalvm ant
  ];

  GRAALVM_BUILD_FLAGS = builtins.concatStringsSep " " [
    "-Dpolyglot.python.CatchAllExceptions=true"
    "-Dpolyglot.python.WithThread=true"
    "-Dorg.graalvm.launcher.relative.home=jre/languages/python/bin/graalpython"
    "-Dpolyglot.python.CAPI=${placeholder "out"}/jre/languages/python"
    "-Dpolyglot.python.CoreHome=${placeholder "out"}/jre/languages/python/lib-graalpython"
    "-Dpolyglot.python.StdLibHome=${placeholder "out"}/jre/languages/python/lib-python/3"
    "-Dpolyglot.python.Executable=graalpython"
  ];

  patches = [ ./setup.py.patch ];

  postPatch = ''
    substituteInPlace graalpython/lib-python/3/distutils/sysconfig_graalpython.py \
      --replace "g['LDSHARED_LINUX'] = " "g['LDSHARED_LINUX'] = '${graalvm}/jre/languages/llvm/native/bin/graalvm-native-ld -shared ' #" \
      --replace 'cc_cmd = cc' 'cc_cmd = "${graalvm}/jre/languages/llvm/native/bin/graalvm-native-clang -I${glibc.dev}/include"'
  '';

  buildPhase = ''
    export CLASSPATH=''${CLASSPATH-}:${builtins.concatStringsSep ":" [
      "${graalvm}/jre/languages/llvm/sulong-api.jar"
      "${graalvm}/jre/lib/graalvm/sulong-toolchain-launchers.jar"
      "${graalvm}/jre/lib/graalvm/launcher-common.jar"
      "${graalvm}/jre/lib/truffle/truffle-api.jar"
      "${graalvm}/jre/lib/truffle/truffle-dsl-processor.jar"
      mavenDepsCp
    ]}

    cp ${ ./build.xml } build.xml

    ant graalpython-launcher-compile
    ant graalpython-launcher-jar
    ant graalpython-antlr-compile
    ${python38}/bin/python graalpython/com.oracle.graal.python.parser.antlr/postprocess.py \
      graalpython/com.oracle.graal.python/src/com/oracle/graal/python/parser/antlr/*.java
    ant graalpython-compile
    ant graalpython-jar

    mkdir -p $out/jre/languages/python
    cp -r graalpython//com.oracle.graal.python.cext/include $out/jre/languages/python
    ln -sf ${graalvm}/include/truffle.h $out/jre/languages/python/include
    ln -sf ${bzip2.dev}/include/bzlib.h $out/jre/languages/python/include

    cp target/jar/*.jar $out/jre/languages/python
    cp -r graalpython/lib-graalpython $out/jre/languages/python
    cp -r graalpython/lib-python $out/jre/languages/python

    cd graalpython/com.oracle.graal.python.cext

    export CLASSPATH=''${CLASSPATH-}:${builtins.concatStringsSep ":" [
      "$out/jre/languages/python/graalpython-launcher.jar"
      "$out/jre/languages/python/graalpython.jar"
    ]}

    java -cp $CLASSPATH ${GRAALVM_BUILD_FLAGS} \
      -Dtruffle.class.path.append=$out/jre/languages/python/graalpython.jar \
      com.oracle.graal.python.shell.GraalPythonMain \
      --experimental-options=true \
      -v -S setup.py $out/jre/languages/python/lib

    native-image  -cp $CLASSPATH ${GRAALVM_BUILD_FLAGS} \
      --language:llvm --language:regex -H:+AddAllCharsets \
      --initialize-at-build-time=com.oracle.graal.python,com.oracle.truffle.regex,org.antlr.v4,jline,org.fusesource \
      com.oracle.graal.python.shell.GraalPythonMain \
      $out/jre/languages/python/bin/graalpython
  '';

  installPhase = ''
    mkdir -p $out/{bin,lib}
    ln -s $out/jre/languages/python/bin/graalpython $out/bin/graalpython
    ln -s $out/jre/languages/python/lib/* $out/lib
  '';

  meta = with stdenv.lib; {
    homepage = https://github.com/graalvm/graalpython;
    description = "A Python 3 implementation built on GraalVM";
    license = licenses.upl;
    maintainers = with maintainers; [ hlolli ];
    platforms = [ "x86_64-linux" ];
  };
}
