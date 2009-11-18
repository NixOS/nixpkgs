{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "lmodern-1.010x";
  
  src = fetchurl {
    url = http://ftp.de.debian.org/debian/pool/main/l/lmodern/lmodern_1.010x.orig.tar.gz;
    sha256 = "0nwxj1ng7rvnp16jxcs25hbc5in65mdk4a3g3rlaq91i5qpq7mxj";
  };

  installPhase = ''
    ensureDir $out/share/texmf/
    ensureDir $out/share/fonts/

    cp -r ./* $out/share/texmf/
    cp -r fonts/{opentype,type1} $out/share/fonts/
  '';

  meta = {
    description = "Latin Modern font";
  };
}

