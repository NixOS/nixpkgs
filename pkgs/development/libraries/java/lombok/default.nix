{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "lombok-1.18.8";

  src = fetchurl {
    url = "https://projectlombok.org/downloads/${name}.jar";
    sha256 = "1z14rc3fh03qvn2xkjrb7ha0hddv3f3vsp781xm336sp4cl9b5h3";
  };

  buildCommand = ''
    mkdir -p $out/share/java
    cp $src $out/share/java/lombok.jar
  '';

  meta = {
    description = "A library that can write a lot of boilerplate for your Java project";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.mit;
    homepage = https://projectlombok.org/;
    maintainers = [ stdenv.lib.maintainers.CrystalGamma ];
  };
}
