args: with args;

stdenv.mkDerivation rec {
  name = "kdegraphics-" + version;
  
  src = fetchurl {
    url = "mirror://kde/stable/${version}/src/${name}.tar.bz2";
    sha256 = "1cvxika98i9xv7fy3drhivixmmm0zd44bfgk5fjfc9ibkcs1fjz7";
  };

  propagatedBuildInputs = [kde4.pimlibs libgphoto2 saneBackends djvulibre exiv2
  poppler chmlib libXxf86vm kde4.support.qimageblitz];
  buildInputs = [cmake];
}
