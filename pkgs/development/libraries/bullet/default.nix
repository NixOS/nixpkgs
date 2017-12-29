{ stdenv, fetchFromGitHub, cmake, mesa, freeglut, darwin }:

stdenv.mkDerivation rec {
  name = "bullet-${version}";
  version = "2.86.1";

  src = fetchFromGitHub {
    owner = "bulletphysics";
    repo = "bullet3";
    rev = version;
    sha256 = "1k81hr5y9rs2nsal6711fal21rxp6h573cpmjjk8x8ji2crqbqlz";
  };

  buildInputs = [ cmake ] ++
    (if stdenv.isDarwin
     then with darwin.apple_sdk.frameworks; [ Cocoa OpenGL ]
     else [mesa freeglut]);

  postPatch = stdenv.lib.optionalString stdenv.isDarwin ''
    sed -i 's/FIND_PACKAGE(OpenGL)//' CMakeLists.txt
    sed -i 's/FIND_LIBRARY(COCOA_LIBRARY Cocoa)//' CMakeLists.txt
  '';

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" "-DBUILD_CPU_DEMOS=OFF" ] ++
    stdenv.lib.optionals stdenv.isDarwin [
      "-DMACOSX_DEPLOYMENT_TARGET=\"10.9\""
      "-DOPENGL_FOUND=true"
      "-DOPENGL_LIBRARIES=${darwin.apple_sdk.frameworks.OpenGL}/Library/Frameworks/OpenGL.framework"
      "-DOPENGL_INCLUDE_DIR=${darwin.apple_sdk.frameworks.OpenGL}/Library/Frameworks/OpenGL.framework"
      "-DOPENGL_gl_LIBRARY=${darwin.apple_sdk.frameworks.OpenGL}/Library/Frameworks/OpenGL.framework"
      "-DCOCOA_LIBRARY=${darwin.apple_sdk.frameworks.Cocoa}/Library/Frameworks/Cocoa.framework"];

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
    platforms = with stdenv.lib.platforms; unix;
  };
}
