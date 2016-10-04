{ stdenv, fetchurl, mkfontscale, mkfontdir }:

stdenv.mkDerivation rec {
  name = "unifont-${version}";
  version = "9.0.02";

  ttf = fetchurl {
    url = "http://fossies.org/linux/unifont/font/precompiled/${name}.ttf";
    sha256 = "14a254gpfyr2ssmbxqwfvh6166vc4klnx2vgz4nybx52bnr9qfkm";
  };

  pcf = fetchurl {
    url = "http://fossies.org/linux/unifont/font/precompiled/${name}.pcf.gz";
    sha256 = "07wn2hlx1x22d2nil0zgsrlgy9b2hdhwly37sr70shp8lkba7wn2";
  };

  buildInputs = [ mkfontscale mkfontdir ];

  phases = "installPhase";

  installPhase =
    ''
      mkdir -p $out/share/fonts $out/share/fonts/truetype
      cp -v ${pcf} $out/share/fonts/unifont.pcf.gz
      cp -v ${ttf} $out/share/fonts/truetype/unifont.ttf
      cd $out/share/fonts
      mkfontdir
      mkfontscale
    '';

  meta = with stdenv.lib; {
    description = "Unicode font for Base Multilingual Plane";
    homepage = http://unifoundry.com/unifont.html;

    # Basically GPL2+ with font exception.
    license = http://unifoundry.com/LICENSE.txt;
    maintainers = [ maintainers.rycee maintainers.vrthra ];
    platforms = platforms.all;
  };
}
