{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, googletest
, cereal
, arrayfire
, oneDNN
, mkl
, mpi
, cudaPackages # optional cuda backend
, opencl ? null # optional opencl backend. opencl requires special hardware
}:

stdenv.mkDerivation rec {
  pname = "flashlight";
  /*
  /nix/store/178vvank67pg2ckr5ic5gmdkm3ri72f3-binutils-2.39/bin/ld: ../../../libflashlight.a(ArrayFireTensor.cpp.o): in function
  `fl::ArrayFireTensor::ArrayFireTensor(af::array&&, unsigned int)':
  ArrayFireTensor.cpp:(.text+0x1943): undefined reference to `af::array::array(af::array&&)'
  */
  #version = "0.4.0";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "flashlight";
    repo = "flashlight";
    rev = "v${version}";
    #sha256 = "sha256-1RgEBA59SydmwSoNlkaO5lwAwcHlgzI4viSkji8I1U8="; # 0.4.0
    sha256 = "sha256-wyMvpL9M7jv2B3K3NYGkgEM31nAPLdT7O955Xf8V3mI=";
  };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    pkg-config
    googletest
    cereal
    arrayfire
    oneDNN
    mkl
    mpi
    cudaPackages.cudnn
    opencl
  ];

  # workaround for https://github.com/NixOS/nixpkgs/issues/213585
  # cmake would replace "/opt" with "/var/empty" in
  # https://github.com/flashlight/flashlight/blob/a97cf69db1a2d8a10b61dbf7f900ed3804525e77/flashlight/fl/tensor/backend/jit/CMakeLists.txt#L7
  preConfigure = ''
    fixCmakeFiles() { return; }
  '';

  meta = {
    homepage = "https://github.com/flashlight/wav2letter";
    description = "A C++ standalone library for machine learning";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ milahu ];
    platforms = lib.platforms.unix;
  };
}
