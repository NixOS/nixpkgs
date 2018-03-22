{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "lombok-1.16.20";

  src = fetchurl {
    url = "https://projectlombok.org/downloads/${name}.jar";
    sha256 = "0v8fq4qlpjh4b87xx35m32y2xpnj4d05xflrgghia6mar8c8n5y5";
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
