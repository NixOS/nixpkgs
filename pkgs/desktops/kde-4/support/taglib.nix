args: with args;

stdenv.mkDerivation {
  name = "taglib-1.4svn";
  
  src = fetchsvn {
    url = svn://anonsvn.kde.org/home/kde/trunk/kdesupport/taglib;
	rev = 732646;
	md5 = "647d68a76858cf3a667656c486b0a8c2";
  };

  buildInputs = [ cmake zlib ];
}
