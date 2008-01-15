args: with args;

stdenv.mkDerivation {
  name = "kdetoys-4.0.0";
  
  src = fetchurl {
    url = mirror://kde/stable/4.0/src/kdetoys-4.0.0.tar.bz2;
    sha256 = "0j7kk4ripg2sw4m8ym96aiyi8rsfb4p7kqp9kmik850flqighhsk";
  };

  buildInputs = [kdelibs kdepimlibs kdeworkspace];
}
