args: with args;

stdenv.mkDerivation {
  name = "kdegraphics-4.0beta4";
  
  src = fetchurl {
    url = mirror://kde/unstable/3.95/src/kdegraphics-3.95.0.tar.bz2;
    sha256 = "0mfsadv9ihhw6s7pcy1yabc21px47nzfs34c76n1888qb09m5dfw";
  };

  buildInputs = [kdelibs kdepimlibs kdeworkspace libgphoto2 saneBackends
  djvulibre exiv2 poppler chmlib];
}
