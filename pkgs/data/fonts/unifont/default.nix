{ stdenv, fetchurl, mkfontscale, mkfontdir }:

stdenv.mkDerivation rec {
  name = "unifont-${version}";
  version = "9.0.01";

  ttf = fetchurl {
    url = "http://fossies.org/linux/unifont/font/precompiled/${name}.ttf";
    sha256 = "0n2vdzrp86bjxfyqgmryrqckmjiiz4jvsfz9amgg3dv2p42y0dhd";
  };

  pcf = fetchurl {
    url = "http://fossies.org/linux/unifont/font/precompiled/${name}.pcf.gz";
    sha256 = "1n3zff46pk6s2x5y7h76aq7h9wfq2acv77gpmxkhz5iwvbpxgb4z";
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
