{ stdenv, fetchurl, mkfontscale, mkfontdir }:

stdenv.mkDerivation rec {
  name = "unifont-${version}";
  version = "9.0.03";

  ttf = fetchurl {
    url = "http://fossies.org/linux/unifont/font/precompiled/${name}.ttf";
    sha256 = "00j97r658xl33zgi66glgbx2s7j9q52cj4iq7z1rrf3p38xzgbff";
  };

  pcf = fetchurl {
    url = "http://fossies.org/linux/unifont/font/precompiled/${name}.pcf.gz";
    sha256 = "1w3gaz8afc3q7svgm4hmgjhvi9pxkmgsib8sscgi52c7ff0mhq9f";
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
