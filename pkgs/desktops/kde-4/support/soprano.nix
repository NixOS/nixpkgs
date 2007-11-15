args: with args;

stdenv.mkDerivation {
  name = "soprano-1.9.0svn";
  
  src = fetchsvn {
    url = svn://anonsvn.kde.org/home/kde/trunk/kdesupport/soprano;
	rev = 732646;
	md5 = "c3b43544536f0f8061e4afeb9e368072";
  };

  CLUCENE_HOME=cluceneCore;
  buildInputs = [ cmake qt cluceneCore redland ];
}
