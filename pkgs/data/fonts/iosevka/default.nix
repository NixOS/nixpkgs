{ stdenv, lib, fetchurl }:

stdenv.mkDerivation rec {
  name = "iosevka-${version}";
  version = "1.0-beta9";
  src = fetchurl {
    url = "https://github.com/be5invis/Iosevka/releases/download/${version}/${name}.tar.bz2";
    sha256 = "1vw34zh8nh6s2dpyw3a1q44wkgrsin1a8b0vnk7hms8s8fw65734";
  };
  unpackPhase = ''
    tar xf "$src"
  '';
  installPhase = ''
    fontdir=$out/share/fonts/iosevka

    mkdir -p $fontdir
    cp -v iosevka-* $fontdir
  '';
  buildInputs = [ ];
  meta = with lib; {
    homepage = "http://be5invis.github.io/Iosevka/";
    description = ''
      Slender monospace sans-serif and slab-serif typeface inspired by Pragmata
      Pro, M+ and PF DIN Mono, designed to be the ideal font for programming.
    '';
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.cstrahan ];
  };
}
