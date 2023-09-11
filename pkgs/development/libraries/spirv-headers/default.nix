{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "spirv-headers";
  version = "1.3.261.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "sdk-${version}";
    hash = "sha256-P/ZD53Xa4Fk9+N/bW5HhsfA+LjUnCbBsQDHvXesKu5M=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Machine-readable components of the Khronos SPIR-V Registry";
    homepage = "https://github.com/KhronosGroup/SPIRV-Headers";
    license = licenses.mit;
    maintainers = [ maintainers.ralith ];
  };
}
