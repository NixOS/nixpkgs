{ stdenv, fetchurl }:

stdenv.mkDerivation {
  name = "tipa-1.3";
  
  src = fetchurl {
    url = "mirror://debian/pool/main/t/tipa/tipa_1.3.orig.tar.gz";
    sha256 = "1q1sisxdcd2zd9b7mnagr2mxf9v3n1r4s5892zx5ly4r0niyya9m";
  };

  installPhase = ''
    export PREFIX="$out/texmf-dist"
    mkdir -p "$PREFIX" "$out/share"
    make install PREFIX="$PREFIX"

    ln -s $out/texmf* $out/share/
  '';

  meta = {
    description = "Phonetic font for TeX";
  };
}


