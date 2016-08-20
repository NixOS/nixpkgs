{ stdenv, fetchFromGitHub, cmake, libGLU_combined, freeglut, darwin }:

stdenv.mkDerivation rec {
  name = "bullet-${version}";
  version = "2.87";

  src = fetchFromGitHub {
    owner = "bulletphysics";
    repo = "bullet3";
    rev = version;
    sha256 = "1msp7w3563vb43w70myjmqsdb97kna54dcfa7yvi9l3bvamb92w3";
  };

  buildInputs = [ cmake ] ++
    (if stdenv.isDarwin
     then with darwin.apple_sdk.frameworks; [ Cocoa OpenGL ]
     else [libGLU_combined freeglut]);

  patches = [ ./gwen-narrowing.patch ];

  postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i 's/FIND_PACKAGE(OpenGL)//' CMakeLists.txt
    sed -i 's/FIND_LIBRARY(COCOA_LIBRARY Cocoa)//' CMakeLists.txt
  '';

  cmakeFlags = {
    BUILD_CPU_DEMOS = false;
    BUILD_SHARED_LIBS = true;
    INSTALL_EXTRA_LIBS = true;
  } // (stdenv.lib.optionalAttrs stdenv.isDarwin {
    COCOA_LIBRARY = "${darwin.apple_sdk.frameworks.Cocoa}/Library/Frameworks/Cocoa.framework";
    MACOSX_DEPLOYMENT_TARGET = "10.9";
    OPENGL_FOUND = true;
    OPENGL_gl_LIBRARY = "${darwin.apple_sdk.frameworks.OpenGL}/Library/Frameworks/OpenGL.framework";
    OPENGL_INCLUDE_DIR = "${darwin.apple_sdk.frameworks.OpenGL}/Library/Frameworks/OpenGL.framework";
    OPENGL_LIBRARIES = "${darwin.apple_sdk.frameworks.OpenGL}/Library/Frameworks/OpenGL.framework";
  });

  enableParallelBuilding = true;

  meta = {
    description = "A professional free 3D Game Multiphysics Library";
    longDescription = ''
      Bullet 3D Game Multiphysics Library provides state of the art collision
      detection, soft body and rigid body dynamics.
    '';
    homepage = http://bulletphysics.org;
    license = stdenv.lib.licenses.zlib;
    maintainers = with stdenv.lib.maintainers; [ aforemny ];
    platforms = with stdenv.lib.platforms; unix;
  };
}
