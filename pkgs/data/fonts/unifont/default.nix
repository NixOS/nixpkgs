{ stdenv, fetchurl, mkfontscale, mkfontdir }:

stdenv.mkDerivation rec {
  name = "unifont-${version}";
  version = "11.0.02";

  ttf = fetchurl {
    url = "mirror://gnu/unifont/${name}/${name}.ttf";
    sha256 = "0l8p07m566131xdinv1pcfc578jpvn72n6dhqmgivp8myai2xkzx";
  };

  pcf = fetchurl {
    url = "mirror://gnu/unifont/${name}/${name}.pcf.gz";
    sha256 = "1hcl71fjchngcb2b4mwl4hhx886faaniv86x2xgk8850766qpnmy";
  };

  nativeBuildInputs = [ mkfontscale mkfontdir ];

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

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "16ni07cfw38s7cj8bdsfi7fa1qahm3k90cmm4gn40qvz35i17x15";

  meta = with stdenv.lib; {
    description = "Unicode font for Base Multilingual Plane";
    homepage = http://unifoundry.com/unifont.html;

    # Basically GPL2+ with font exception.
    license = http://unifoundry.com/LICENSE.txt;
    maintainers = [ maintainers.rycee maintainers.vrthra ];
    platforms = platforms.all;
  };
}
