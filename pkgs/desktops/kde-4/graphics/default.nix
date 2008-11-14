args: with args;

stdenv.mkDerivation {
  name = "kdegraphics-4.0.0";

  src = fetchurl {
    url = mirror://kde/stable/4.0.0/src/kdegraphics-4.0.0.tar.bz2;
    md5 = "6cad7b165d99c43d1a19a0350598821c";
  };

  buildInputs = [kdelibs kdepimlibs kdeworkspace libgphoto2 saneBackends
  djvulibre exiv2 poppler chmlib];
}
