args: with args;

stdenv.mkDerivation {
  name = "soprano-1.9.0svn";
  src = svnSrc "soprano" "02xfp7g41ahxwczkxipyi13rav6akhwgspxdhgk5gm94rg10hq2l";
  CLUCENE_HOME=cluceneCore;
  buildInputs = [ cmake qt cluceneCore redland ];
}
