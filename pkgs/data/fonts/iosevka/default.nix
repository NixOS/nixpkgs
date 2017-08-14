{ stdenv, fetchzip }:

let
  version = "1.13.1";
in fetchzip rec {
  name = "iosevka-${version}";

  url = "https://github.com/be5invis/Iosevka/releases/download/v${version}/iosevka-pack-${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.ttc -d $out/share/fonts/iosevka
  '';

  sha256 = "0w35jkvfnzn4clm3010wv13sil2yj6pxffx40apjp7yhh19c4sw7";

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
