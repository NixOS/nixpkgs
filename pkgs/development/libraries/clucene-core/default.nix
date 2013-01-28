{stdenv, fetchurl}:

stdenv.mkDerivation rec {
  name = "clucene-core-0.9.21b";

  src = fetchurl {
    url = "mirror://sourceforge/clucene/${name}.tar.bz2";
    sha256 = "202ee45af747f18642ae0a088d7c4553521714a511a1a9ec99b8144cf9928317";
  };
  
  meta = {
    description = "CLucene is a port of the very popular Java Lucene text search engine API. Core package.";
    homepage = http://clucene.sourceforge.net;
  };
}
