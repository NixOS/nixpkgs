{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "spirv-headers";
  version = "1.3.216.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "sdk-${version}";
    hash = "sha256-qYhFoRrQOlvYvVXhIFsa3dZuORDpZyVC5peeYmGNimw=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Machine-readable components of the Khronos SPIR-V Registry";
    license = licenses.mit;
    maintainers = [ maintainers.ralith ];
  };
}
