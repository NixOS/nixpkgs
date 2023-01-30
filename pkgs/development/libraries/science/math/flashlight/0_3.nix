{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, googletest
, cereal
, stb
, arrayfire
, oneDNN
, mkl
, mpi
, cudaPackages
, cudatoolkit
, dnnl
, gloo
, cudaSupport ? false # GPU backend
, cudnnSupport ? false # GPU backend
, mklSupport ? false # CPU backend
, oneDNNSupport ? false # CPU backend
#, glooSupport ? false # CPU distributed training
, backendOption ? "CPU" # CUDA, CPU, OPENCL
, distributedOption ? true # needed for wav2letter
}:

let
  # TODO validate backendOption: assert ...
in

stdenv.mkDerivation rec {
  pname = "flashlight";
  version = "0.3.2";

  src = fetchFromGitHub {
    owner = "flashlight";
    repo = "flashlight";
    rev = "v${version}";
    sha256 = "sha256-wyMvpL9M7jv2B3K3NYGkgEM31nAPLdT7O955Xf8V3mI=";
  };

  nativeBuildInputs = [
    cmake
  ];

  cmakeFlags = [
    ("-DFL_BACKEND=" + backendOption)
    # distributed training
    ("-DFL_BUILD_DISTRIBUTED=" + (if distributedOption then "ON" else "OFF"))
    # offline build
    "-DFL_BUILD_STANDALONE=OFF"
    ("-DUSE_GLOO=" + (if (backendOption == "CPU" && distributedOption) then "ON" else "OFF"))
    ("-DUSE_NCCL=" + (if (backendOption == "GPU" && distributedOption) then "ON" else "OFF"))
    # -DUSE_STATIC_CUDNN=OFF
    #
  ];

  buildInputs = [
    pkg-config
    googletest
    cereal
    stb # https://github.com/nothings/stb
    arrayfire
    mpi
    #glog # app: all
    #gflags # app: all
    #libsndfile # app: asr (wav2letter)
  ] ++ (lib.optionals (backendOption == "GPU" && cudaSupport) [
    cudatoolkit
  ]) ++ (lib.optionals (backendOption == "GPU" && cudnnSupport) [
    cudaPackages.cudnn
  ]) ++ (lib.optionals (backendOption == "GPU" && distributedOption) [
    cudaPackages.nccl
  ]) ++ (lib.optionals (backendOption == "CPU" && mklSupport) [
    mkl
  ]) ++ (lib.optionals (backendOption == "CPU") [
    dnnl
  ]) ++ (lib.optionals (backendOption == "CPU" && oneDNNSupport) [
    oneDNN
  ]) ++ (lib.optionals (backendOption == "CPU" && distributedOption) [
    gloo
  ]);

  # workaround for https://github.com/NixOS/nixpkgs/issues/213585
  # cmake would replace "/opt" with "/var/empty" in
  # https://github.com/flashlight/flashlight/blob/a97cf69db1a2d8a10b61dbf7f900ed3804525e77/flashlight/fl/tensor/backend/jit/CMakeLists.txt#L7
  preConfigure = ''
    fixCmakeFiles() { return; }
  '';

  meta = {
    homepage = "https://github.com/flashlight/flashlight/tree/0.3";
    description = "A C++ standalone library for machine learning";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ milahu ];
    platforms = lib.platforms.unix;
  };
}
