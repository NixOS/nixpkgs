{ stdenv, fetchurl, jdk, jre, ant, coreutils, gnugrep }:

stdenv.mkDerivation rec {

  version = "1.0.2";
  name = "arduino-core";

  src = fetchurl {
    url = "http://arduino.googlecode.com/files/arduino-${version}-src.tar.gz";
    sha256 = "0nszl2hdjjgxk87gyk0xi0ww9grbq83hch3iqmpaf9yp4y9bra0x";
  };

  buildInputs = [ jdk ant ];

  phases = "unpackPhase patchPhase buildPhase installPhase";

  patchPhase = ''
  #
  '';

  buildPhase = ''
    cd ./core && ant 
    cd ../build && ant 
    cd ..
  '';

  installPhase = ''
    mkdir -p $out/share/arduino
    cp -r ./build/linux/work/hardware/ $out/share/arduino
    cp -r ./build/linux/work/libraries/ $out/share/arduino
    cp -r ./build/linux/work/tools/ $out/share/arduino
    cp -r ./build/linux/work/lib/ $out/share/arduino
    echo ${version} > $out/share/arduino/lib/version.txt
  '';

  meta = {
    description = "Arduino libraries";
    homepage = http://arduino.cc/;
    license = "GPL";
    maintainers = [ stdenv.lib.maintainers.antono ];
  }; 
}
