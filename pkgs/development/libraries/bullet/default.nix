{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  libGLU,
  libGL,
  freeglut,
  Cocoa,
  OpenGL,
}:

stdenv.mkDerivation rec {
  pname = "bullet";
  version = "3.25";

  src = fetchFromGitHub {
    owner = "bulletphysics";
    repo = "bullet3";
    rev = version;
    sha256 = "sha256-AGP05GoxLjHqlnW63/KkZe+TjO3IKcgBi+Qb/osQuCM=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs =
    lib.optionals stdenv.isLinux [
      libGLU
      libGL
      freeglut
    ]
    ++ lib.optionals stdenv.isDarwin [
      Cocoa
      OpenGL
    ];

  postPatch =
    ''
      substituteInPlace examples/ThirdPartyLibs/Gwen/CMakeLists.txt \
        --replace "-DGLEW_STATIC" "-DGLEW_STATIC -Wno-narrowing"
    ''
    + lib.optionalString stdenv.isDarwin ''
      sed -i 's/FIND_PACKAGE(OpenGL)//' CMakeLists.txt
      sed -i 's/FIND_LIBRARY(COCOA_LIBRARY Cocoa)//' CMakeLists.txt
    '';

  cmakeFlags =
    [
      "-DBUILD_SHARED_LIBS=ON"
      "-DBUILD_CPU_DEMOS=OFF"
      "-DINSTALL_EXTRA_LIBS=ON"
    ]
    ++ lib.optionals stdenv.isDarwin [
      "-DOPENGL_FOUND=true"
      "-DOPENGL_LIBRARIES=${OpenGL}/Library/Frameworks/OpenGL.framework"
      "-DOPENGL_INCLUDE_DIR=${OpenGL}/Library/Frameworks/OpenGL.framework"
      "-DOPENGL_gl_LIBRARY=${OpenGL}/Library/Frameworks/OpenGL.framework"
      "-DCOCOA_LIBRARY=${Cocoa}/Library/Frameworks/Cocoa.framework"
      "-DBUILD_BULLET2_DEMOS=OFF"
      "-DBUILD_UNIT_TESTS=OFF"
      "-DBUILD_BULLET_ROBOTICS_GUI_EXTRA=OFF"
    ];

  env.NIX_CFLAGS_COMPILE = lib.optionalString stdenv.cc.isClang "-Wno-error=argument-outside-range -Wno-error=c++11-narrowing";

  meta = with lib; {
    description = "A professional free 3D Game Multiphysics Library";
    longDescription = ''
      Bullet 3D Game Multiphysics Library provides state of the art collision
      detection, soft body and rigid body dynamics.
    '';
    homepage = "http://bulletphysics.org";
    license = licenses.zlib;
    maintainers = with maintainers; [ aforemny ];
    platforms = platforms.unix;
  };
}
