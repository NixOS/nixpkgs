{ stdenv, fetchzip }:

fetchzip {
  name = "junicode-0.7.8";

  url = mirror://sourceforge/junicode/junicode/junicode-0-7-8/junicode-0-7-8.zip;

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.ttf -d $out/share/fonts/junicode-ttf
  '';

  sha256 = "0q4si9pnbif36154sv49kzc7ygivgflv81nzmblpz3b2p77g9956";

  meta = {
    homepage = http://junicode.sourceforge.net/;
    description = "A Unicode font for medievalists";
    platforms = stdenv.lib.platforms.unix;
    license = stdenv.lib.licenses.gpl2Plus;
  };
}
