{ stdenv, fetchFromGitHub, cmake, mesa, freeglut }:

stdenv.mkDerivation rec {
  name = "bullet-${version}";
  version = "2.83.7";

  src = fetchFromGitHub {
    owner = "bulletphysics";
    repo = "bullet3";
    rev = version;
    sha256 = "1zz3vs6i5975y9mgb1k1vxrjbf1028v0nc11p646dsvv2vplxx5r";
  };

  buildInputs = [ cmake mesa freeglut ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" "-DBUILD_CPU_DEMOS=OFF" ];

  enableParallelBuilding = true;

  meta = {
    description = "A professional free 3D Game Multiphysics Library";
    longDescription = ''
      Bullet 3D Game Multiphysics Library provides state of the art collision
      detection, soft body and rigid body dynamics. 
    '';
    homepage = http://code.google.com/p/bullet/;
    license = stdenv.lib.licenses.zlib;
    maintainers = with stdenv.lib.maintainers; [ aforemny ];
  };
}
