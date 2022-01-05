{ lib, stdenv, fetchFromGitHub, cmake, boost, zlib }:

stdenv.mkDerivation rec {
  pname = "assimp";
  version = "5.1.3";
  outputs = [ "out" "lib" "dev" ];

  src = fetchFromGitHub{
    owner = "assimp";
    repo = "assimp";
    rev = "v${version}";
    hash = "sha256-GNSfaP8O5IsjGwtC3DFaV4OiMMUXIcmHmz+5TCT/HP8=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost zlib ];

  meta = with lib; {
    description = "A library to import various 3D model formats";
    homepage = "https://www.assimp.org/";
    license = licenses.bsd3;
    maintainers = with maintainers; [ ehmry ];
    platforms = platforms.linux ++ platforms.darwin;
  };
}
