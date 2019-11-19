{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "fluid-soundfont";
  version = "3.1";

  src = fetchurl {
    url = "http://http.debian.net/debian/pool/main/f/${pname}/${pname}_${version}.orig.tar.gz";
    sha256 = "0hq35wa8418qwfk6lvckfq9fcxy51hin7ldx4kdspr3q3jmaq896";
  };

  sourceRoot = ".";

  installPhase = ''
    install -Dm644 ${name}/FluidR3_GM.sf2 $out/share/soundfonts/FluidR3_GM.sf2
    install -Dm644 ${name}/FluidR3_GS.sf2 $out/share/soundfonts/FluidR3_GS.sf2
  '';

  meta = with stdenv.lib; {
    description = "Pro-quality GM/GS soundfont";
    longDescription = ''
      FluidR3 is the third release of Frank Wen's pro-quality GM/GS soundfont.
      The soundfont has lots of excellent samples, including all the GM instruments
      along side with the GS instruments that are recycled and reprogrammed versions
      of the GM presets.
    '';
    homepage = http://www.hammersound.net/;
    license = licenses.mit;
    platforms = platforms.all;
    maintainers = with maintainers; [ abbradar ];
  };
}
