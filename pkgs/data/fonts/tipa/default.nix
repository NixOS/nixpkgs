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

    ln -s -r $out/texmf* $out/share/
  '';

  outputHashAlgo = "sha256";
  outputHashMode = "recursive";
  outputHash = "1g2cclykr6ax584rlcri8w2h385n624sgfx2fm45r0cwkg1p77h2";

  meta = {
    description = "Phonetic font for TeX";
  };
}


