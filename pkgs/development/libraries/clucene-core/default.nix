args: with args;

stdenv.mkDerivation rec {
  name = "clucene-core-0.9.20";

  src = fetchurl {
    url = "mirror://sf/clucene/${name}.tar.bz2";
    sha256 = "1hwq3b4qp1dgygmypgpg3blj68wnksq2rbqkwyxvl5dldn12q7rg";
  };
  
  meta = {
    description = "CLucene is a port of the very popular Java Lucene text search engine API. Core package.";
    homepage = http://clucene.sourceforge.net;
  };
}
