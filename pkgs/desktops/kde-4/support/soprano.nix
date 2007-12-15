args: with args;

stdenv.mkDerivation {
  name = "soprano-1.9.0svn";
  src = svnSrc "soprano" "1zzn84k6m351y9pr0kkxb1d4i3jb3mkyyqc07bq0im56m8bvrcm7";
  CLUCENE_HOME=cluceneCore;
  buildInputs = [ cmake qt cluceneCore redland ];
}
