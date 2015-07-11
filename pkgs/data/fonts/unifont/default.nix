{ stdenv, fetchurl, mkfontscale, mkfontdir }:

stdenv.mkDerivation rec {
  name = "unifont-${version}";
  version = "8.0.01";

  ttf = fetchurl {
    url = "http://fossies.org/linux/unifont/font/precompiled/${name}.ttf";
    sha256 = "0g4g2n024072cdrs2wjp7xmkr3i9dm52a5g9hiafxjgj5a45c8kl";
  };

  pcf = fetchurl {
    url = "http://fossies.org/linux/unifont/font/precompiled/${name}.pcf.gz";
    sha256 = "0mpdy2k7z9s60x8i6sbv64p9wrihfwgrw81x5yj13rl6x7zzghr8";
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
