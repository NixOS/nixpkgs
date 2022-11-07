{ lib
, stdenv
, fetchFromGitHub
, cmake
, rocm-cmake
, rocm-device-libs
, clang
}:

stdenv.mkDerivation rec {
  pname = "clang-ocl";
  rocmVersion = "5.3.1";
  version = rocmVersion;

  src = fetchFromGitHub {
    owner = "RadeonOpenCompute";
    repo = "clang-ocl";
    rev = "rocm-${rocmVersion}";
    hash = "sha256-uMSvcVJj+me2E+7FsXZ4l4hTcK6uKEegXpkHGcuist0=";
  };

  nativeBuildInputs = [
    cmake
    rocm-cmake
    clang
  ];

  buildInputs = [
    rocm-device-libs
  ];

  cmakeFlags = [
    "-DCMAKE_C_COMPILER=clang"
    "-DCMAKE_CXX_COMPILER=clang++"
  ];

  meta = with lib; {
    description = "OpenCL compilation with clang compiler";
    homepage = "https://github.com/RadeonOpenCompute/clang-ocl";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ Madouura ];
    broken = rocmVersion != clang.version;
  };
}
