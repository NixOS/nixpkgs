{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "lombok-1.18.10";

  src = fetchurl {
    url = "https://projectlombok.org/downloads/${name}.jar";
    sha256 = "1ymjwxg01dq8qq89hx23yvk5h46hwfb8ihbqbvabmz1vh9afjdi8";
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
