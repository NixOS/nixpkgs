args: with args;

stdenv.mkDerivation {
  name = "soprano-1.9.0svn";
  src = svnSrc "soprano" "3d487cf96f03ab34353ca1547bb60025b5bb67354f1fe63ddb4822d14a78fc7c";
  CLUCENE_HOME=cluceneCore;
  buildInputs = [ cmake qt cluceneCore redland ];
}
