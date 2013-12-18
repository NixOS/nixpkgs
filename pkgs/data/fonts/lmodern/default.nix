{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "lmodern-2.004.4";
  
  src = fetchurl {
    url = mirror://debian/pool/main/l/lmodern/lmodern_2.004.4.orig.tar.gz;
    sha256 = "1g1fmi9asw6x9arm5sy3r4jwz7zrrbcw6q4waj3iqs0iq525i1rw";
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

