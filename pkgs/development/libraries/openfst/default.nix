{ stdenv, fetchurl, autoreconfHook }:

stdenv.mkDerivation rec {
  pname = "openfst";
  version = "1.8.0";

  src = fetchurl {
    url = "http://www.openfst.org/twiki/pub/FST/FstDownload/${pname}-${version}.tar.gz";
    sha256 = "0h2lfhhihg63b804hrcljnkggijbjmp84i5g8q735wb09y9z2c4p";
  };

  configureFlags = [
    "--enable-compact-fsts"
    "--enable-compress"
    "--enable-const-fsts"
    "--enable-far"
    "--enable-linear-fsts"
    "--enable-lookahead-fsts"
    "--enable-mpdt"
    "--enable-ngram-fsts"
    "--enable-pdt"
  ];

  enableParallelBuilding = true;

  nativeBuildInputs = [ autoreconfHook ];

  meta = with stdenv.lib; {
    description = "Library for working with finite-state transducers";
    longDescription = ''
      Library for constructing, combining, optimizing, and searching weighted finite-state transducers (FSTs).
      FSTs have key applications in speech recognition and synthesis, machine translation, optical character recognition,
      pattern matching, string processing, machine learning, information extraction and retrieval among others
    '';
    homepage = "http://www.openfst.org/twiki/bin/view/FST/WebHome";
    license = licenses.asl20;
    maintainers = [ maintainers.dfordivam ];
    platforms = platforms.unix;
  };
}
