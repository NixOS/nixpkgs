{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "lmodern-2.004.1";
  
  src = fetchurl {
    url = mirror://debian/pool/main/l/lmodern/lmodern_2.004.1.orig.tar.gz;
    sha256 = "1bvlf8p39667q58pvyfzy3yl0mylf0ak96flwp8vj01vqbi3rfaz";
  };

  installPhase = ''
    mkdir -p $out/texmf-dist/
    mkdir -p $out/share/fonts/

    cp -r ./* $out/texmf-dist/
    cp -r fonts/{opentype,type1} $out/share/fonts/

    ln -s $out/texmf* $out/share/
  '';

  meta = {
    description = "Latin Modern font";
  };
}

