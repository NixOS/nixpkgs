{ stdenv, fetchurl }:

stdenv.mkDerivation rec {
  name = "${pname}-${version}";
  pname = "openfst";
  version = "1.7.2";

  src = fetchurl {
    url = "http://www.openfst.org/twiki/pub/FST/FstDownload/${name}.tar.gz";
    sha256 = "0fqgk8195kz21is09gwzwnrg7fr9526bi9mh4apyskapz27pbhr1";
  };
  meta = {
    description = "Library for working with finite-state transducers";
    longDescription = ''
      Library for constructing, combining, optimizing, and searching weighted finite-state transducers (FSTs).
      FSTs have key applications in speech recognition and synthesis, machine translation, optical character recognition,
      pattern matching, string processing, machine learning, information extraction and retrieval among others
    '';
    homepage = http://www.openfst.org/twiki/bin/view/FST/WebHome;
    license = stdenv.lib.licenses.asl20;
    maintainers = [ stdenv.lib.maintainers.dfordivam ];
    platforms = stdenv.lib.platforms.unix;
  };
}

