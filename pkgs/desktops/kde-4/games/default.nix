args: with args;

stdenv.mkDerivation {
  name = "kdegames-4.0beta4";
  
  src = fetchurl {
    url = mirror://kde/unstable/3.95/src/kdegames-3.95.0.tar.bz2;
    sha256 = "1zsfslnazl8gmiq51y5d16svv7p92yvs2zsz13zg7zpwy4afxzbp";
  };

  buildInputs = [kdelibs kdepimlibs kdeworkspace];
}
