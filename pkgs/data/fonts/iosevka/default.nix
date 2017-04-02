{ stdenv, fetchurl, unzip }:

stdenv.mkDerivation rec {
  name = "iosevka-${version}";
  version = "1.11.4";

  buildInputs = [ unzip ];

  src = fetchurl {
    url = "https://github.com/be5invis/Iosevka/releases/download/v${version}/01-iosevka-${version}.zip";
    sha256 = "0mn9pqkambsal5cvz8hzlwx7qvcdfch8g1iy7mqhgghzflfhsy8x";
  };

  sourceRoot = ".";

  installPhase = ''
    fontdir=$out/share/fonts/iosevka

    mkdir -p $fontdir
    cp -v iosevka-* $fontdir
  '';

  meta = with stdenv.lib; {
    homepage = "http://be5invis.github.io/Iosevka/";
    downloadPage = "https://github.com/be5invis/Iosevka/releases";
    description = ''
      Slender monospace sans-serif and slab-serif typeface inspired by Pragmata
      Pro, M+ and PF DIN Mono, designed to be the ideal font for programming.
    '';
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = [ maintainers.cstrahan ];
  };
}
