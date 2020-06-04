{ stdenv, fetchzip }:

let
  version = "3.1.1";
in fetchzip {
  name = "iosevka-bin-${version}";

  url = "https://github.com/be5invis/Iosevka/releases/download/v${version}/ttc-iosevka-${version}.zip";

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.ttc -d $out/share/fonts/iosevka
  '';

  sha256 = "1byzycph7hmmpjngv6c5bhf854a476dx0nnkrgminddk3q5pgxgz";

  meta = with stdenv.lib; {
    homepage = "https://be5invis.github.io/Iosevka/";
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
