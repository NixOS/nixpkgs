args: with args;

stdenv.mkDerivation {
  name = "eigen-1.0.5";
  
  src = fetchsvn {
    url = svn://anonsvn.kde.org/home/kde/trunk/kdesupport/eigen;
	rev = 732646;
	md5 = "f91ad5d3dd992984fb61107fd9050a36";
  };

  buildInputs = [ cmake ];
}
