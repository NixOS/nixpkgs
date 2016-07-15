{ stdenv, fetchFromGitHub }:

stdenv.mkDerivation rec {
  name = "iosevka-${version}";
  version = "1.4.2";

  src = fetchFromGitHub {
    owner  = "be5invis";
    repo   = "Iosevka";
    rev    = "v${version}";
    sha256 = "1h1lmvjpjk0238bhdhnv2c149s98qpbndc8rxzlk6bhmxcy6rwsk";
  };

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
