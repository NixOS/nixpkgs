{ lib, mkFont, fetchzip }:

mkFont rec {
  pname = "gyre-fonts";
  version = "2.005";

  src = fetchzip {
    url = "http://www.gust.org.pl/projects/e-foundry/tex-gyre/whole/tg-${version}otf.zip";
    sha256 = "0f1sxvghy3zcshci2d6hma213n2hqxbkwi46bq5qmy2zw5z2x8pv";
    stripRoot = false;
  };

  meta = {
    description = "OpenType fonts from the Gyre project, suitable for use with (La)TeX";
    longDescription = ''
      The Gyre project started in 2006, and will
      eventually include enhanced releases of all 35 freely available
      PostScript fonts distributed with Ghostscript v4.00.  These are
      being converted to OpenType and extended with diacritical marks
      covering all modern European languages and then some
    '';
    homepage = "http://www.gust.org.pl/projects/e-foundry/tex-gyre/index_html#Readings";
    license = lib.licenses.lppl13c;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ bergey ];
  };
}
