{ lib
, stdenv
, fetchFromGitHub
, cmake
, hip
, python3
}:

stdenv.mkDerivation rec {
  pname = "rocmlir";
  rocmVersion = "5.3.1";
  # For some reason they didn't add a tag for 5.3.1, should be compatible, change to rocmVersion later
  version = "5.3.0";

  src = fetchFromGitHub {
    owner = "ROCmSoftwarePlatform";
    repo = "rocMLIR";
    rev = "rocm-${version}"; # change to rocmVersion later
    hash = "sha256-s/5gAH5vh2tgATZemPP66juQFDg8BR2sipzX2Q6pOOQ=";
  };

  nativeBuildInputs = [
    cmake
    hip
  ];

  buildInputs = [
    python3
  ];

  cmakeFlags = [
    "-DBUILD_FAT_LIBMLIRMIOPEN=ON"
  ];

  meta = with lib; {
    description = "MLIR-based convolution and GEMM kernel generator";
    homepage = "https://github.com/ROCmSoftwarePlatform/rocMLIR";
    license = with licenses; [ asl20 ];
    maintainers = with maintainers; [ Madouura ];
    broken = rocmVersion != hip.version;
  };
}
