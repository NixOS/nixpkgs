{ stdenv, fetchFromGitHub, cmake, libGLU_combined, freeglut
, Cocoa,  OpenGL
}:

stdenv.mkDerivation rec {
  name = "bullet-${version}";
  version = "2.87";

  src = fetchFromGitHub {
    owner = "bulletphysics";
    repo = "bullet3";
    rev = version;
    sha256 = "1msp7w3563vb43w70myjmqsdb97kna54dcfa7yvi9l3bvamb92w3";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = stdenv.lib.optionals stdenv.isLinux [ libGLU_combined freeglut ]
    ++ stdenv.lib.optionals stdenv.isDarwin [ Cocoa OpenGL ];

  patches = [ ./gwen-narrowing.patch ];

  postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i 's/FIND_PACKAGE(OpenGL)//' CMakeLists.txt
    sed -i 's/FIND_LIBRARY(COCOA_LIBRARY Cocoa)//' CMakeLists.txt
  '';

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS=ON"
    "-DBUILD_CPU_DEMOS=OFF"
    "-DINSTALL_EXTRA_LIBS=ON"
  ] ++ stdenv.lib.optionals stdenv.isDarwin [
    "-DOPENGL_FOUND=true"
    "-DOPENGL_LIBRARIES=${OpenGL}/Library/Frameworks/OpenGL.framework"
    "-DOPENGL_INCLUDE_DIR=${OpenGL}/Library/Frameworks/OpenGL.framework"
    "-DOPENGL_gl_LIBRARY=${OpenGL}/Library/Frameworks/OpenGL.framework"
    "-DCOCOA_LIBRARY=${Cocoa}/Library/Frameworks/Cocoa.framework"
    "-DBUILD_BULLET2_DEMOS=OFF"
    "-DBUILD_UNIT_TESTS=OFF"
  ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "A professional free 3D Game Multiphysics Library";
    longDescription = ''
      Bullet 3D Game Multiphysics Library provides state of the art collision
      detection, soft body and rigid body dynamics.
    '';
    homepage = http://bulletphysics.org;
    license = licenses.zlib;
    maintainers = with maintainers; [ aforemny ];
    platforms = platforms.unix;
  };
}
