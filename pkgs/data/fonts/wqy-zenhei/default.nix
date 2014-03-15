{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "wqy-zenhei-${version}";
  version = "0.9.45";

  src = fetchurl {
    url = "mirror://sourceforge/wqy/${name}.tar.gz";
    sha256 = "1mkmxq8g2hjcglb3zajfqj20r4r88l78ymsp2xyl5yav8w3f7dz4";
  };

  dontBuild = true;

  installPhase =
    ''
      mkdir -p $out/share/fonts
      install -m644 *.ttc $out/share/fonts/
    '';

  meta = {
    description = "A (mainly) Chinese Unicode font";
    homepage = "http://wenq.org";
    license = stdenv.lib.licenses.gpl2; # with font embedding exceptions
    maintainers = stdenv.lib.maintainers.pkmx;
    platforms = stdenv.lib.platforms.all;
  };
}

