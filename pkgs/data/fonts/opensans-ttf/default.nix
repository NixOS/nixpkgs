{stdenv, fetchzip}:

fetchzip {
  name = "opensans-ttf-20140617";

  url = "http://web.archive.org/web/20150801161609/https://hexchain.org/pub/archlinux/ttf-opensans/opensans.tar.gz";

  postFetch = ''
    tar -xzf $downloadedFile
    mkdir -p $out/share/fonts/truetype
    cp *.ttf $out/share/fonts/truetype
  '';

  sha256 = "0zpzqw5y9g5jk7xjcxa12ds60ckvxmpw8p7bnkkmad53s94yr5wf";

  meta = {
    description = "Open Sans fonts";
    longDescription = ''
      Open Sans is a humanist sans serif typeface designed by Steve Matteson,
      Type Director of Ascender Corp.
    '';
    homepage = https://en.wikipedia.org/wiki/Open_Sans;
    license = stdenv.lib.licenses.asl20;
    platforms = stdenv.lib.platforms.all;
    maintainers = [ ];
  };
}
