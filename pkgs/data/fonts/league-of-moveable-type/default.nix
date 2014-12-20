{stdenv, fetchurl, unzip}:

stdenv.mkDerivation rec {
  baseName = "league-of-moveable-type";
  version = "2014-12";
  name="${baseName}-${version}";

  srcs = [(fetchurl {
    url = "https://www.theleagueofmoveabletype.com/league-gothic/download";
    sha256 = "0nbwsbwhs375kbis3lpk98dw05mnh455vghjg1cq0j2fsj1zb99b";
    name = "league-gothic.zip";
  })

  (fetchurl {
    url = "https://www.theleagueofmoveabletype.com/fanwood/download";
    sha256 = "1023da7hik8ci8s7rcy6lh4h9p6igx1kz9y1a2cv6sizbp819w8g";
    name = "fanwood.zip";
  })

  (fetchurl {
    url = "https://www.theleagueofmoveabletype.com/linden-hill/download";
    sha256 = "0rm92rz9kki91l5wcn149mdpwq1mfql4dv6d159hv534qmg3z3ks";
    name = "linden-hill.zip";
  })

  (fetchurl {
    url = "https://www.theleagueofmoveabletype.com/raleway/download";
    sha256 = "0f6anym0adq0ankqbdqx4lyzbysx824zqdj1x60gafyisjx48y87";
    name = "raleway.zip";
  })

  (fetchurl {
    url = "https://www.theleagueofmoveabletype.com/prociono/download";
    sha256 = "11hamjry5lx3cykzpjq7kwlp6h9cjqy470fmn9f2pi954b46xkdy";
    name = "prociono.zip";
  })

  (fetchurl {
    url = "https://www.theleagueofmoveabletype.com/goudy-bookletter-1911/download";
    sha256 = "01qganq5n7rgqw546lf45kj8j7ymfjr00i2bwp3qw7ibifg9pn4n";
    name = "goudy-bookletter-1911.zip";
  })

  (fetchurl {
    url = "https://www.theleagueofmoveabletype.com/sorts-mill-goudy/download";
    sha256 = "11aywj5lzapk04k2yzi1g96acbbm48x902ka0v9cfwwqpn6js9ra";
    name = "sorts-mill-goudy.zip";
  })


];

  buildInputs = [unzip];

  sourceRoot = ".";

  installPhase = ''
    mkdir -p $out/share/fonts/truetype
    cp */*.otf $out/share/fonts/truetype
  '';


  meta = {
    description = "Font Collection by The League of Moveable Type";

    longDescription = '' We're done with the tired old fontstacks of
      yesteryear. The web is no longer limited, and now it's time to raise
      our standards. Since 2009, The League has given only the most
      well-made, free & open-source, @font-face ready fonts.
    '';

    homepage = "https://www.theleagueofmoveabletype.com/";

    license = stdenv.lib.licenses.ofl;

    platforms = stdenv.lib.platforms.all;
    maintainers = with stdenv.lib.maintainers; [ bergey ];
  };
}
