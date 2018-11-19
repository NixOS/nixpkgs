{ stdenv, fetchzip }:

fetchzip {
  name = "lmodern-2.004.5";

  url = mirror://debian/pool/main/l/lmodern/lmodern_2.004.5.orig.tar.gz;

  postFetch = ''
    tar xzvf $downloadedFile

    mkdir -p $out/texmf-dist/
    mkdir -p $out/share/fonts/

    cp -r lmodern-2.004.5/* $out/texmf-dist/
    cp -r lmodern-2.004.5/fonts/{opentype,type1} $out/share/fonts/

    ln -s -r $out/texmf* $out/share/
  '';

  sha256 = "0f3nszrvs1nqyhsvjgrnnlam72sz741fyggg9261n9slrkql1jja";

  meta = {
    description = "Latin Modern font";
    platforms = stdenv.lib.platforms.unix;
  };
}

