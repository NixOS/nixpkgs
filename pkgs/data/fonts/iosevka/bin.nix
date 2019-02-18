{ stdenv, fetchzip }:

let
  version = "2.1.0";
in fetchzip rec {
  name = "iosevka-bin-${version}";

  url = "https://github.com/be5invis/Iosevka/releases/download/v${version}/ttc-iosevka-${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.ttc -d $out/share/fonts/iosevka
  '';

  sha256 = "0hx91pdkiw0qvkkl7qnl78p5afldcmn18l5m1iclldnvrghrxizz";

  meta = with stdenv.lib; {
    homepage = https://be5invis.github.io/Iosevka/;
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
