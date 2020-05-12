{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  pname = "openfst";
  version = "1.7.6";

  src = fetchurl {
    url = "http://www.openfst.org/twiki/pub/FST/FstDownload/${pname}-${version}.tar.gz";
    sha256 = "03hs0196qbjfbviqn6nnb7igvv3cnpxyizlwlzmx88a6fhiq97bm";
  };
  meta = {
    description = "Library for working with finite-state transducers";
    longDescription = ''
      Library for constructing, combining, optimizing, and searching weighted finite-state transducers (FSTs).
      FSTs have key applications in speech recognition and synthesis, machine translation, optical character recognition,
      pattern matching, string processing, machine learning, information extraction and retrieval among others
    '';
    homepage = "http://www.openfst.org/twiki/bin/view/FST/WebHome";
    license = stdenv.lib.licenses.asl20;
    maintainers = [ stdenv.lib.maintainers.dfordivam ];
    platforms = stdenv.lib.platforms.unix;
  };
}

