args: with args;

stdenv.mkDerivation {
  name = "qimageblitz-4.0.0svn";
  
  src = fetchsvn {
    url = svn://anonsvn.kde.org/home/kde/trunk/kdesupport/qimageblitz;
	rev = 732646;
	md5 = "c37fa505368071ec501e966225e30c78";
  };

  buildInputs = [cmake qt];
}
