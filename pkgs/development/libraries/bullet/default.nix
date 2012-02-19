{stdenv, fetchurl, unzip, cmake}:

stdenv.mkDerivation {
  name = "bullet-2.78";
  src = fetchurl {
    url = "http://bullet.googlecode.com/files/bullet-2.78.zip";
    sha256 = "10l2dclvv0di9mi9qp6xfy9vybx182xp2dyygabacrpr3p75s77k";
  };
  buildInputs = [ unzip cmake ];
  configurePhase = ''
    cmake -DBUILD_SHARED_LIBS=ON -DBUILD_EXTRAS=OFF -DBUILD_DEMOS=OFF .
  '';

  meta = {
    description = "A professional free 3D Game Multiphysics Library";
    longDescription = ''
      Bullet 3D Game Multiphysics Library provides state of the art collision
      detection, soft body and rigid body dynamics. 
    '';
    homepage = http://code.google.com/p/bullet/;
    license = stdenv.lib.licenses.zlib;
    maintainers = [ "Alexander Foremny <alexanderforemny@googlemail.com>" ];
  };
}
