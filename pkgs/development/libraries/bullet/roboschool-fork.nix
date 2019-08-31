{ stdenv, fetchFromGitHub, cmake, libGLU_combined, freeglut
, Cocoa,  OpenGL
}:

stdenv.mkDerivation rec {
  pname = "bullet";
  version = "2019-03-27";

  src = fetchFromGitHub {
    owner = "olegklimov";
    repo = "bullet3";
    # roboschool needs the HEAD of a specific branch of this fork, see
    # https://github.com/openai/roboschool/issues/126#issuecomment-421643980
    # https://github.com/openai/roboschool/pull/62
    # https://github.com/openai/roboschool/issues/124
    rev = "3687507ddc04a15de2c5db1e349ada3f2b34b3d6";
    sha256 = "1wd7vj9136dl7lfb8ll0rc2fdl723y3ls9ipp7657yfl2xrqhvkb";
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
    platforms = platforms.unix;
  };
}
