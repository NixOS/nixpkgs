{ stdenv, fetchurl, unzip, jdk }:
stdenv.mkDerivation rec {
  name = "bcprov-jdk15on-153";
  nativeBuildInputs = [ unzip jdk ];
  src = fetchurl {
    url = "http://www.bouncycastle.org/download/bcprov-jdk15on-153.tar.gz";
    sha256 = "ef4a4fdb2777ee62a787304afe17c5401df869dc5d74cc5306f1270e3cb69615";
  };
  buildPhase = "
    unpackFile src.zip
    find org -name 'test' -prune -o -name '*.java' -print0 | xargs -0 javac -encoding UTF-8
    mkdir build
    find org -name '*.class' -print0 | xargs -0 cp --parents -t build
    jar cf ${name}.jar -C build .
  ";
  installPhase = ''
    mkdir -p "$out/share/java";
    cp ${name}.jar $out/share/java
  '';
  meta = {
    description = "A Java implementation of cryptographic algorithms";
    homepage = "http://www.bouncycastle.org/java.html";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
  };
}
