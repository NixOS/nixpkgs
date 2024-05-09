{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "spirv-headers";
  version = "1.3.280.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "vulkan-sdk-${version}";
    hash = "sha256-kyOAwe4R0FmeA9IIJF2eoZR+7g9LiGKaZ7FuIfkrXJ4=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Machine-readable components of the Khronos SPIR-V Registry";
    homepage = "https://github.com/KhronosGroup/SPIRV-Headers";
    license = licenses.mit;
    maintainers = [ maintainers.ralith ];
  };
}
