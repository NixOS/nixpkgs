{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "unifont_upper-${version}";
  version = "9.0.03";

  ttf = fetchurl {
    url = "http://unifoundry.com/pub/unifont-${version}/font-builds/${name}.ttf";
    sha256 = "015v39y6nnyz4ld006349jzk9isyaqp4cnvmz005ylfnicl4zwhi";
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
