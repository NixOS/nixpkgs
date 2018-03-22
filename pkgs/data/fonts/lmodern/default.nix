{ stdenv, fetchzip }:

fetchzip {
  name = "lmodern-2.004.4";

  url = mirror://debian/pool/main/l/lmodern/lmodern_2.004.4.orig.tar.gz;

  postFetch = ''
    tar xzvf $downloadedFile

    mkdir -p $out/texmf-dist/
    mkdir -p $out/share/fonts/

    cp -r lmodern-2.004.4/* $out/texmf-dist/
    cp -r lmodern-2.004.4/fonts/{opentype,type1} $out/share/fonts/

    ln -s -r $out/texmf* $out/share/
  '';

  sha256 = "13n7ls8ss4sffd6c1iw2wb5hbq642i0fmivm76mbqwf652l002i5";

  meta = {
    description = "Latin Modern font";
    platforms = stdenv.lib.platforms.unix;
  };
}

