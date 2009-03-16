args: with args;

stdenv.mkDerivation {
  name = "kdetoys-4.0.0";

  src = fetchurl {
    url = mirror://kde/stable/4.0.0/src/kdetoys-4.0.0.tar.bz2;
    md5 = "6e4e2eea3d87718f48716f975b48ada2";
  };

  buildInputs = [kdelibs kdepimlibs kdeworkspace];
}
