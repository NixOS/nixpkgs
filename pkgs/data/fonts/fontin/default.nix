{ stdenv, fetchzip }:
fetchzip rec {
  name = "fontin";

  url = http://www.exljbris.com/dl/fontin_pc.zip;

  postFetch = ''
    mkdir -p $out/share/fonts
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
  '';

  sha256 = "1aizmyl62j0cncwp783ka1jlmk9g8jkwaxsg1564rx1i6zybbp4p";

  meta = with stdenv.lib; {
    homepage = https://www.exljbris.com/fontin.html;
    description = "The Fontin free font";
    longDescription = ''
      This is designed to be used at small sizes. It's available in Roman, italic, bold & small caps. The color is darkish, the spacing loose and the x-height tall.
    '';
    license = https://www.exljbris.com/eula.html;
    platforms = platforms.all;
    maintainers = with maintainers; [ mredaelli ];
  };
}
