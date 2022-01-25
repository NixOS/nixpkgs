{ lib, stdenv, fetchFromGitHub, fetchpatch, cmake, boost, zlib }:

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

  patches = [
    # Fix include directory with split outputs
    # https://github.com/assimp/assimp/pull/4337
    (fetchpatch {
      url = "https://github.com/assimp/assimp/commit/5dcaf445c3da079cf43890a0688428a7e1de0b30.patch";
      sha256 = "sha256-KwqTAoDPkhFq469+VaUuGoqfymu2bWLG9W3BvFvyU5I=";
    })
  ];

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
