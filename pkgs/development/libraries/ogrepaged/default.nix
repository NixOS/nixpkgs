{ stdenv, fetchurl, cmake, pkgconfig, ois, ogre, libX11, boost }:

stdenv.mkDerivation rec {
  name = "ogre-paged-${version}";
  version = "1.2.0";

  src = fetchurl {
    url = "https://github.com/RigsOfRods/ogre-pagedgeometry/archive/v${version}.tar.gz";
    sha256 = "17j7rw9wbkynxbhm2lay3qgjnnagb2vd5jn9iijnn2lf8qzbgy82";
  };

  buildInputs = [ ois ogre libX11 boost ];
  nativeBuildInputs = [ cmake pkgconfig ];

  cmakeFlags = "-DPAGEDGEOMETRY_BUILD_SAMPLES=OFF";

  enableParallelBuilding = true;

  meta = {
    description = "Paged Geometry for Ogre3D";
    homepage = http://code.google.com/p/ogre-paged/;
    license = stdenv.lib.licenses.mit;
  };
}
