{ stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "spirv-headers";
  version = "1.4.1";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = version;
    sha256 = "1zfmvg3x0q9w652s8g5m5rcckzm6jiiw8rif2qck4vlsryl55akp";
  };

  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    inherit (src.meta) homepage;
    description = "Machine-readable components of the Khronos SPIR-V Registry";
    license = licenses.mit;
    maintainers = [ maintainers.ralith ];
  };
}
