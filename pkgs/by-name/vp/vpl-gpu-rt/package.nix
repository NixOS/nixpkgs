{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, libdrm
, libva
}:

stdenv.mkDerivation rec {
  pname = "vpl-gpu-rt";
  version = "24.2.2";

  outputs = [ "out" "dev" ];

  src = fetchFromGitHub {
    owner = "intel";
    repo = "vpl-gpu-rt";
    rev = "intel-onevpl-${version}";
    sha256 = "sha256-JtvRh4p4wPRnqFfE86tJW+yS9AKMoi3TPZO+LZ2Q7Mo=";
  };

  nativeBuildInputs = [ cmake pkg-config ];

  buildInputs = [ libdrm libva ];

  meta = {
    description = "oneAPI Video Processing Library Intel GPU implementation";
    homepage = "https://github.com/intel/vpl-gpu-rt";
    changelog = "https://github.com/intel/vpl-gpu-rt/releases/tag/${src.rev}";
    license = [ lib.licenses.mit ];
    platforms = lib.platforms.linux;
    # CMake adds x86 specific compiler flags in <source>/builder/FindGlobals.cmake
    # NOTE: https://github.com/oneapi-src/oneVPL-intel-gpu/issues/303
    broken = !stdenv.hostPlatform.isx86;
    maintainers = [ lib.maintainers.evanrichter ];
  };
}
