{ lib, stdenv, fetchFromGitHub, cmake }:

let
  basis_universal = fetchFromGitHub {
    owner = "zeux";
    repo = "basis_universal";
    rev = "8903f6d69849fd782b72a551a4dd04a264434e20";
    hash = "sha256-o3dCxAAkpMoNkvkM7qD75cPn/obDc/fJ8u7KLPm1G6g=";
  };
in stdenv.mkDerivation {
  pname = "meshoptimizer";
  version = "unstable-2023-03-22";
  src = fetchFromGitHub {
    owner = "zeux";
    repo = "meshoptimizer";
    hash = "sha256-OWeptdnKFvTyfkz0sFCpiTI7323GfVE8vb8bNUBnslA=";
    rev = "49d9222385daf61a9ce75bb4699472408eb3df3e";
  };

  nativeBuildInputs = [ cmake ];

  outputs = [ "bin" "dev" "out" ];

  cmakeFlags = [
    "-DMESHOPT_BUILD_GLTFPACK=ON"
    "-DMESHOPT_BASISU_PATH=${basis_universal}"
  ] ++ lib.optional (!stdenv.hostPlatform.isStatic)
    "-DMESHOPT_BUILD_SHARED_LIBS:BOOL=ON";

  meta = with lib; {
    description = "Mesh optimization library that makes meshes smaller and faster to render";
    homepage = "https://github.com/zeux/meshoptimizer";
    license = licenses.mit;
    maintainers = [ maintainers.lillycham ];
    platforms = platforms.all;
    mainProgram = "gltfpack";
  };
}
