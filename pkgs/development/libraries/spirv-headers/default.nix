{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "spirv-headers";
  version = "2020-01-27";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "faa570afbc91ac73d594d787486bcf8f2df1ace0";
    sha256 = "jgjBTkPTGl4aU4nk/ZdLHUneC5/o3PCCnlmbCtQjLsY=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Machine-readable components of the Khronos SPIR-V Registry";
    license = licenses.mit;
    maintainers = [ maintainers.ralith ];
  };
}
