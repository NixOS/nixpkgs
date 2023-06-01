{ lib, stdenv, fetchFromGitHub, cmake }:

stdenv.mkDerivation rec {
  pname = "spirv-headers";
  version = "1.3.243.0";

  src = fetchFromGitHub {
    owner = "KhronosGroup";
    repo = "SPIRV-Headers";
    rev = "sdk-${version}";
    hash = "sha256-VOq3r6ZcbDGGxjqC4IoPMGC5n1APUPUAs9xcRzxdyfk=";
  };

  nativeBuildInputs = [ cmake ];

  # https://github.com/KhronosGroup/SPIRV-Headers/issues/282
  postPatch = ''
    substituteInPlace SPIRV-Headers.pc.in \
      --replace '$'{prefix}/@CMAKE_INSTALL_INCLUDEDIR@ @CMAKE_INSTALL_FULL_INCLUDEDIR@
  '';

  meta = with lib; {
    description = "Machine-readable components of the Khronos SPIR-V Registry";
    homepage = "https://github.com/KhronosGroup/SPIRV-Headers";
    license = licenses.mit;
    maintainers = [ maintainers.ralith ];
  };
}
