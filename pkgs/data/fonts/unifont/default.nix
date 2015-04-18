{ stdenv, fetchurl, mkfontscale, mkfontdir }:

stdenv.mkDerivation rec {
  name = "unifont-${version}";
  version = "7.0.06";

  ttf = fetchurl {
    url = "http://unifoundry.com/pub/${name}/font-builds/${name}.ttf";
    sha256 = "0qmk06rwhxs43n1xbwj14fanbih60zqli002qhy0609da24r3957";
  };

  pcf = fetchurl {
    url = "http://unifoundry.com/pub/${name}/font-builds/${name}.pcf.gz";
    sha256 = "1wplig57wpc79mlqamhknn39cibg5z8dvbyibp1490ljcjs1dxdc";
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
    maintainers = [ maintainers.rycee ];
    platforms = platforms.all;
  };
}
