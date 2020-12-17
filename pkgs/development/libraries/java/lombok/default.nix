{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "lombok-1.18.16";

  src = fetchurl {
    url = "https://projectlombok.org/downloads/${name}.jar";
    sha256 = "1msys7xkaj0d7fi112fmb2z50mk46db58agzrrdyimggsszwn1kj";
  };

  buildCommand = ''
    mkdir -p $out/share/java
    cp $src $out/share/java/lombok.jar
  '';

  meta = {
    description = "A library that can write a lot of boilerplate for your Java project";
    platforms = stdenv.lib.platforms.all;
    license = stdenv.lib.licenses.mit;
    homepage = "https://projectlombok.org/";
    maintainers = [ stdenv.lib.maintainers.CrystalGamma ];
  };
}
