{ stdenv, autoreconfHook, fetchurl, openfst }:

stdenv.mkDerivation rec {
  pname = "opengrm-ngram";
  version = "1.3.11";

  src = fetchurl {
    url = "http://www.openfst.org/twiki/pub/GRM/NGramDownload/ngram-${version}.tar.gz";
    sha256 = "0wwpcj8qncdr9f2pmi0vhlw277dyxr85ygdi8g57xp2ifysigm05";
  };

  nativeBuildInputs = [ autoreconfHook ];

  buildInputs = [ openfst ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Library to make and modify n-gram language models encoded as weighted finite-state transducers";
    homepage = "http://www.openfst.org/twiki/bin/view/GRM/NGramLibrary";
    license = licenses.asl20;
    maintainers = with maintainers; [ mic92 ];
    platforms = platforms.unix;
  };
}
