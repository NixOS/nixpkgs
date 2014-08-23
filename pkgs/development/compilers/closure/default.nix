{ stdenv, fetchurl, jre, gnutar, bash }:

stdenv.mkDerivation rec {
  name = "closure-compiler-${version}";
  version = "20130603";

  src = fetchurl {
    url = "http://dl.google.com/closure-compiler/compiler-${version}.tar.gz";
    sha256 = "0bk0s8p9r9an5m0l8y23wjlx490k15i4zah0a384a2akzji8y095";
  };

  phases = [ "installPhase" ];

  buildInputs = [ gnutar ];

  installPhase = ''
    mkdir -p $out/share/java $out/bin
    tar -xzf $src
    cp -r compiler.jar $out/share/java/
    echo "#!${bash}/bin/bash" > $out/bin/closure-compiler
    echo "${jre}/bin/java -jar $out/share/java/compiler.jar \"\$@\"" >> $out/bin/closure-compiler
    chmod +x $out/bin/closure-compiler
  '';

  meta = {
    description = "A tool for making JavaScript download and run faster";
    homepage = https://developers.google.com/closure/compiler/;
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.linux;
  };
}
