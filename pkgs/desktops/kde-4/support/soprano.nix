args: with args;

stdenv.mkDerivation {
  name = "soprano-1.9.0svn";
  src = svnSrc "soprano" "1j61jf8vzamknmzmrxpwba9v7c0vnb8zmlh9n0sgawjgbzfgq2zn";
  CLUCENE_HOME=cluceneCore;
  buildInputs = [ cmake qt cluceneCore redland ];
}
