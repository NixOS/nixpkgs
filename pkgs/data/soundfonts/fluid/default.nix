{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "Fluid-3";

  src = fetchurl {
    url = "https://ftp.osuosl.org/pub/musescore/soundfont/fluid-soundfont.tar.gz";
    sha256 = "1f96bi0y6rms255yr8dfk436azvwk66c99j6p43iavyq8jg7c5f8";
  };

  sourceRoot = ".";

  installPhase = ''
    install -Dm644 "FluidR3 GM2-2.SF2" $out/share/soundfonts/FluidR3_GM2-2.sf2
  '';

  meta = with stdenv.lib; {
    description = "Frank Wen's pro-quality GM/GS soundfont";
    homepage = http://www.hammersound.net/;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ abbradar ];
  };
}
