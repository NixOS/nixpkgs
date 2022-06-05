{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "spirv-headers";
  version = "1.3.211.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "sdk-${version}";
    sha256 = "sha256-LkIrTFWYvZffLVJJW3152um5LTEsMJEDEsIhBAdhBlk=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Machine-readable components of the Khronos SPIR-V Registry";
    license = licenses.mit;
    maintainers = [ maintainers.ralith ];
  };
}
