args: with args;

stdenv.mkDerivation {
  name = "kdegraphics-4.0.0";
  
  src = fetchurl {
    url = mirror://kde/stable/4.0.0/src/kdegraphics-4.0.0.tar.bz2;
    sha256 = "00np19mzmg8zs8j89g1f47h3kj5azgnv3nspb8lw880zg682yp2f";
  };

  propagatedBuildInputs = [kdepimlibs libgphoto2 saneBackends djvulibre exiv2
  poppler chmlib libXxf86vm];
  buildInputs = [cmake];
}
