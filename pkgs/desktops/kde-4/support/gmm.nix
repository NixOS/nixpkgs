args: with args;

stdenv.mkDerivation {
  name = "gmm-svn";
  
  src = fetchsvn {
    url = svn://anonsvn.kde.org/home/kde/trunk/kdesupport/gmm;
	rev = 732646;
	md5 = "09ee4cfcbb3c428bc681c2da022648bf";
  };

  buildInputs = [ cmake ];
}
