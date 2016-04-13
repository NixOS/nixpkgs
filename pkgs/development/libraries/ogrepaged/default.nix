{ stdenv, fetchurl, cmake, pkgconfig, ois, ogre, libX11, boost }:

stdenv.mkDerivation rec {
  name = "ogre-paged-1.1.3";

  src = fetchurl {
    url = "http://ogre-paged.googlecode.com/files/${name}.tar.gz";
    sha256 = "1qqlkg17plk87dm3fsm34x8lkd5rxkhiz77ppcgc71a7z050vhjq";
  };

  buildInputs = [ ois ogre libX11 boost ];
  nativeBuildInputs = [ cmake pkgconfig ];

  cmakeFlags = [ "-DPAGEDGEOMETRY_BUILD_SAMPLES=OFF" ];

  enableParallelBuilding = true;

  meta = {
    description = "Paged Geometry for Ogre3D";
    homepage = http://code.google.com/p/ogre-paged/;
    license = stdenv.lib.licenses.mit;
    # Build failures
    broken = true;
  };
}
