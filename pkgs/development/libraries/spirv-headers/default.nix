{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "spirv-headers";
  version = "1.2.198.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "sdk-${version}";
    sha256 = "sha256-cdEiRSCoX0New8ecUh7UTDz/is2v29zhf6Il2N1j3mw=";
  };

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    inherit (src.meta) homepage;
    description = "Machine-readable components of the Khronos SPIR-V Registry";
    license = licenses.mit;
    maintainers = [ maintainers.ralith ];
  };
}
