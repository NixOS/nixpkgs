{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "marisa-${version}";
  version = "0.2.4";

  src = fetchurl {
    url = "https://storage.googleapis.com/google-code-archive-downloads/v2/code.google.com/marisa-trie/marisa-${version}.tar.gz";
    sha256 = "1cwzf8hr348zihkiy0qckx0n6rxg7sy113xhbslb1irw1pvs99v7";
  };

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    homepage    = https://code.google.com/p/marisa-trie/;
    description = "Static and space-efficient trie data structure library";
    license     = licenses.bsd3;
    maintainers = with maintainers; [ sifmelcara ];
    platforms   = platforms.all;
  };
}
