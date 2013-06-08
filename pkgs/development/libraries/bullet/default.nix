{ stdenv, fetchurl, cmake, mesa, freeglut }:

stdenv.mkDerivation rec {
  name = "bullet-2.80"; # vdrift 2012-07-22 doesn't build with 2.81
  rev = "2531";
  src = fetchurl {
    url = "http://bullet.googlecode.com/files/${name}-rev${rev}.tgz";
    sha256 = "0dig6k88jz5y0cz6dn186vc4l96l4v56zvwpsp5bv9f5wdwjskj6";
  };

  buildInputs = [ cmake mesa freeglut ];
  configurePhase = ''
    cmake -DBUILD_SHARED_LIBS=ON -DBUILD_EXTRAS=OFF -DBUILD_DEMOS=OFF \
      -DCMAKE_INSTALL_PREFIX=$out .
  '';

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
