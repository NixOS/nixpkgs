args: with args;

stdenv.mkDerivation {
  name = "kdegraphics-4.0rc2";
  
  src = fetchurl {
    url = mirror://kde/unstable/3.97/src/kdegraphics-3.97.0.tar.bz2;
    sha256 = "0f16zyvw37nqhbis34rg6yxg6r95yk2vi9lk3zk8lqjwcs81h5fz";
  };

  buildInputs = [kdelibs kdepimlibs libgphoto2 saneBackends
  djvulibre exiv2 poppler chmlib];
}
