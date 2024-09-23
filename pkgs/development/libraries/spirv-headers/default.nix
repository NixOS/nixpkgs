{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "spirv-headers";
  version = "1.3.290.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "vulkan-sdk-${version}";
    hash = "sha256-c9ruBCnf9PNJz030bfRhHwyqju6T8YCRx+efKCEYgSo=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Machine-readable components of the Khronos SPIR-V Registry";
    homepage = "https://github.com/KhronosGroup/SPIRV-Headers";
    license = licenses.mit;
    maintainers = [ maintainers.ralith ];
  };
}
