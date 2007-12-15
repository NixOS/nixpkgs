args: with args;

stdenv.mkDerivation {
  name = "kdegames-4.0rc2";
  
  src = fetchurl {
    url = mirror://kde/unstable/3.97/src/kdegames-3.97.0.tar.bz2;
    sha256 = "12a87lfaqlidjlibxk3q43bdza2c6k5ggqblxdnr8ikjdww2sk29";
  };

  buildInputs = [kdelibs kdepimlibs];
}
