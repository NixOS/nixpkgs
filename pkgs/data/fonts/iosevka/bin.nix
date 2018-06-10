{ stdenv, fetchzip }:

let
  version = "1.14.3";
in fetchzip rec {
  name = "iosevka-bin-${version}";

  url = "https://github.com/be5invis/Iosevka/releases/download/v${version}/iosevka-pack-${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.ttc -d $out/share/fonts/iosevka
  '';

  sha256 = "0qc5i6ijr25d2jwi5r4bcvbaw74y1p05a5fvlwss3l9rhmmxsfpl";

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
