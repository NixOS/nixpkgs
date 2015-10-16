{ stdenv, fetchurl, unzip, jdk, bcprov }:
stdenv.mkDerivation rec {
  name = "bcpkix-jdk15on-153";
  nativeBuildInputs = [ unzip jdk ];
  src = fetchurl {
    url = "http://www.bouncycastle.org/download/bcpkix-jdk15on-153.tar.gz";
    sha256 = "140b1b6a75171a0476e1f148946de01ccd0ae9025e14ff6b748846901efab151";
  };
  buildInputs = [ bcprov ];
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
    description = "A Java implementation of PKIX/CMS/EAC/PKCS/OCSP/TSP/OPENSSL algorithms";
    homepage = "http://www.bouncycastle.org/java.html";
    license = stdenv.lib.licenses.mit;
    platforms = stdenv.lib.platforms.all;
  };
}
