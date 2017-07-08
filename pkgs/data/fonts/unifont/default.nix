{ stdenv, fetchurl, mkfontscale, mkfontdir }:

stdenv.mkDerivation rec {
  name = "unifont-${version}";
  version = "10.0.02";

  ttf = fetchurl {
    url = "mirror://gnu/unifont/${name}/${name}.ttf";
    sha256 = "1g7iaw2vx7yq8d3z625p6ainkn35wpfsimbl75lyj3d8206fhx0z";
  };

  pcf = fetchurl {
    url = "mirror://gnu/unifont/${name}/${name}.pcf.gz";
    sha256 = "1l2cnkshpsg3mw5ps1ghzqm2a1nr7jfdn2bxqyvw7d0l5xyxvg3d";
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
