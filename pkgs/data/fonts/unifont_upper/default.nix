{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "unifont_upper-${version}";
  version = "8.0.01";

  ttf = fetchurl {
    url = "http://unifoundry.com/pub/unifont-8.0.01/font-builds/${name}.ttf";
    sha256 = "0ffqm85bk345pnql1x0rbg0z31472y844xibb27njjg4avb21lga";
  };

  phases = "installPhase";

  installPhase =
    ''
      mkdir -p $out/share/fonts/truetype
      cp -v ${ttf} $out/share/fonts/truetype/unifont_upper.ttf
    '';

  meta = with stdenv.lib; {
    description = "Unicode font for glyphs above the Unicode Basic Multilingual Plane";
    homepage = http://unifoundry.com/unifont.html;

    # Basically GPL2+ with font exception.
    license = http://unifoundry.com/LICENSE.txt;
    maintainers = [ maintainers.mathnerd314 ];
    platforms = platforms.all;
  };
}
