{ lib
, stdenv
, fetchFromGitHub
, cmake
, boost
, zlib
}:

stdenv.mkDerivation rec {
  pname = "assimp";
  version = "5.2.5";
  outputs = [ "out" "lib" "dev" ];

  src = fetchFromGitHub{
    owner = "assimp";
    repo = "assimp";
    rev = "v${version}";
    hash = "sha256-vQx+PaET5mlvvIGHk6pEnZvM3qw8DiC3hd1Po6OAHxQ=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost zlib ];

  cmakeFlags = [ "-DASSIMP_BUILD_ASSIMP_TOOLS=ON" ];

  meta = with lib; {
    description = "A library to import various 3D model formats";
    homepage = "https://www.assimp.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ehmry ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
