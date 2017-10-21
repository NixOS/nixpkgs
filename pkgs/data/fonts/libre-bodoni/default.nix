{ stdenv, fetchzip }:

fetchzip rec {
  name = "libre-bodoni-2.000";

  url = https://github.com/impallari/Libre-Bodoni/archive/995a40e8d6b95411d660cbc5bb3f726ffd080c7d.zip;

  postFetch = ''
    mkdir -p $out/share/{doc,fonts}
    unzip -j $downloadedFile \*/v2000\ -\ initial\ glyphs\ migration/OTF/\*.otf  -d $out/share/fonts/opentype
    unzip -j $downloadedFile \*README.md \*FONTLOG.txt                           -d "$out/share/doc/${name}"
  '';

  sha256 = "0pnb1xydpvcl9mkz095f566kz7yj061wbf40rwrbwmk706f6bsiw";

  meta = with stdenv.lib; {
    description = "Bodoni fonts adapted for today's web requirements";
    longDescription = ''
      The Libre Bodoni fonts are based on the 19th century Morris Fuller
      Benton's ATF design, but specifically adapted for today's web
      requirements.

      They are a perfect choice for everything related to elegance, style,
      luxury and fashion.

      Libre Bodoni currently features four styles: Regular, Italic, Bold and
      Bold Italic.
    '';
    homepage = https://github.com/impallari/Libre-Bodoni;
    license = licenses.ofl;
    maintainers = with maintainers; [ cmfwyp ];
    platforms = platforms.all;
  };
}
