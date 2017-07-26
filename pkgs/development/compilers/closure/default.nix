{ stdenv, fetchurl, jre, gnutar, bash }:

stdenv.mkDerivation rec {
  name = "closure-compiler-${version}";
  version = "20170218";

  src = fetchurl {
    url = "http://dl.google.com/closure-compiler/compiler-${version}.tar.gz";
    sha256 = "06snabmpy07x4xm8d1xgq5dfzbjli10xkxk3nx9jms39zkj493cd";
  };

  phases = [ "installPhase" ];

  buildInputs = [ gnutar ];

  installPhase = ''
    mkdir -p $out/share/java $out/bin
    tar -xzf $src
    cp -r closure-compiler-v${version}.jar $out/share/java/
    echo "#!${bash}/bin/bash" > $out/bin/closure-compiler
    echo "${jre}/bin/java -jar $out/share/java/closure-compiler-v${version}.jar \"\$@\"" >> $out/bin/closure-compiler
    chmod +x $out/bin/closure-compiler
  '';

  meta = {
    description = "A tool for making JavaScript download and run faster";
    homepage = https://developers.google.com/closure/compiler/;
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.unix;
  };
}
