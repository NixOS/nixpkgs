{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "unifont_upper-${version}";
  version = "9.0.01";

  ttf = fetchurl {
    url = "http://unifoundry.com/pub/unifont-9.0.01/font-builds/${name}.ttf";
    sha256 = "06b7na4vb2fjn0zn14bmarzn6vb3ndkysixc89kmb2cc24kfpix1";
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
    maintainers = [ maintainers.mathnerd314 maintainers.vrthra ];
    platforms = platforms.all;
  };
}
