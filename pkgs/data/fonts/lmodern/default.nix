{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "lmodern-2.004.5";
  
  src = fetchurl {
    url = mirror://debian/pool/main/l/lmodern/lmodern_2.004.5.orig.tar.gz;
    sha256 = "1xd8bhlpqin0javx4210vh9vpzz2kmckvzsllhq824mfdl30s8mf";
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

