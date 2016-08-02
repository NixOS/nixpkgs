{ stdenv, fetchurl, cmake, mesa, freeglut }:

stdenv.mkDerivation rec {
  name = "bullet-2.83.7"; # vdrift 2012-07-22 doesn't build with 2.81
  src = fetchurl {
    url = "https://github.com/bulletphysics/bullet3/archive/2.83.7.tar.gz";
    sha256 = "0hqjnmlb2p29yiasrm7kvgv0nklz5zkwhfk4f78zz1gf0vrdil80";
  };

  buildInputs = [ cmake mesa freeglut ];
  configurePhase = ''
    cmake -DBUILD_SHARED_LIBS=ON -DINSTALL_EXTRA_LIBS=TRUE \
      -DCMAKE_INSTALL_PREFIX=$out .
  '';

  enableParallelBuilding = true;

  meta = {
    description = "A professional free 3D Game Multiphysics Library";
    longDescription = ''
      Bullet 3D Game Multiphysics Library provides state of the art collision
      detection, soft body and rigid body dynamics. 
    '';
    homepage = https://github.com/bulletphysics/bullet3;
    license = stdenv.lib.licenses.zlib;
    maintainers = with stdenv.lib.maintainers; [ aforemny ];
    platforms = with stdenv.lib.platforms; linux;
  };
}
