args: with args;

stdenv.mkDerivation {
  name = "kdegames-4.0.0";

  src = fetchurl {
    url = mirror://kde/stable/4.0.0/src/kdegames-4.0.0.tar.bz2;
    md5 = "6264c0034f6389a2807a4e1723ba1c81";
  };

  buildInputs = [kdelibs kdepimlibs kdeworkspace];
}
