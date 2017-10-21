{ stdenv, fetchzip }:

let
  version = "1.017";
in fetchzip {
  name = "source-serif-pro-${version}";

  url = "https://github.com/adobe-fonts/source-serif-pro/archive/${version}R.zip";

  postFetch = ''
    mkdir -p $out/share/fonts/opentype
    unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
  '';

  sha256 = "04447fbj7lwr2qmmvy7d7624qdh4in7hp627nsc8vbpxmb7bbmn1";

  meta = with stdenv.lib; {
    homepage = http://sourceforge.net/adobe/sourceserifpro;
    description = "A set of OpenType fonts to complement Source Sans Pro";
    license = licenses.ofl;
    platforms = platforms.all;
    maintainers = with maintainers; [ ttuegel ];
  };
}

