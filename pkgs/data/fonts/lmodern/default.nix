{ fetchzip }:

fetchzip {
  name = "lmodern-2.005";

  url = "mirror://debian/pool/main/l/lmodern/lmodern_2.005.orig.tar.gz";

  postFetch = ''
    tar xzvf $downloadedFile

    mkdir -p $out/texmf-dist/
    mkdir -p $out/share/fonts/

    cp -r lmodern-2.005/* $out/texmf-dist/
    cp -r lmodern-2.005/fonts/{opentype,type1} $out/share/fonts/

    ln -s -r $out/texmf* $out/share/
  '';

  sha256 = "sha256-ySdKUt8o5FqmpdnYSzbGJ1f9t8VmKYXqPt53e1/E/FA=";

  meta = {
    description = "Latin Modern font";
  };
}

