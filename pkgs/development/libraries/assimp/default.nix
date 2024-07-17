{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "assimp";
  version = "5.4.2";
  outputs = [
    "out"
    "lib"
    "dev"
  ];

  src = fetchFromGitHub {
    owner = "assimp";
    repo = "assimp";
    rev = "v${version}";
    hash = "sha256-4KpqH3rSNSTAXMFPWAvGTZA4jzKIChHFdtW97sK2EyY=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [
    boost
    zlib
  ];

  cmakeFlags = [ "-DASSIMP_BUILD_ASSIMP_TOOLS=ON" ];

  env.NIX_CFLAGS_COMPILE = toString ([
    # Needed with GCC 12
    "-Wno-error=array-bounds"
  ]);

  meta = with lib; {
    description = "Library to import various 3D model formats";
    mainProgram = "assimp";
    homepage = "https://www.assimp.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ehmry ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
