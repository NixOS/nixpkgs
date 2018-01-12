{ stdenv, fetchzip }:

let
  version = "1.13.3";
in fetchzip rec {
  name = "iosevka-bin-${version}";

  url = "https://github.com/be5invis/Iosevka/releases/download/v${version}/iosevka-pack-${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.ttc -d $out/share/fonts/iosevka
  '';

  sha256 = "0103rjxcp2sis42xp7fh7g8i03h5snvs8n78lgsf79g8ssw0p9d4";

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
