{ stdenv, fetchurl }:
let
  version = "2.0.3";
in
stdenv.mkDerivation {
  name = "cinnamon-translations-${version}";

  src = fetchurl {
    url = "http://github.com/linuxmint/cinnamon-translations/archive/${version}.tar.gz";
    sha256 = "07w3v118xrfp8r4dkbdiyd1vr9ah7f3bm2zw9wag9s8l8x0zfxgc";
  };

  installPhase =
    ''
      mkdir -pv $out/share/cinnamon/locale
      cp -av mo-export/* $out/share/cinnamon/locale/
    '';

  meta = {
    homepage = "http://cinnamon.linuxmint.com";
    description = "Translations files for the Cinnamon desktop" ;

    platforms = stdenv.lib.platforms.linux;
    maintainers = [ stdenv.lib.maintainers.roelof ];
  };
}

