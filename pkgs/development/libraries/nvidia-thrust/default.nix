{ lib
, config
, fetchFromGitHub
, stdenv
, cmake
, pkg-config
, cudaPackages ? { }
, symlinkJoin
, tbb
, hostSystem ? "CPP"
, deviceSystem ? if config.cudaSupport or false then "CUDA" else "OMP"
}:

# Policy for device_vector<T>
assert builtins.elem deviceSystem [
  "CPP" # Serial on CPU
  "OMP" # Parallel with OpenMP
  "TBB" # Parallel with Intel TBB
  "CUDA" # Parallel on GPU
];

# Policy for host_vector<T>
# Always lives on CPU, but execution can be made parallel
assert builtins.elem hostSystem [ "CPP" "OMP" "TBB" ];

let
  pname = "nvidia-thrust";
  version = "1.16.0";

  inherit (cudaPackages) backendStdenv cudaFlags;
  cudaCapabilities = map cudaFlags.dropDot cudaFlags.cudaCapabilities;

  tbbSupport = builtins.elem "TBB" [ deviceSystem hostSystem ];
  cudaSupport = deviceSystem == "CUDA";

  # TODO: Would like to use this:
  cudaJoined = symlinkJoin {
    name = "cuda-packages-unsplit";
    paths = with cudaPackages; [
      cuda_nvcc
      cuda_nvrtc # symbols: cudaLaunchDevice, &c; notice postBuild
      cuda_cudart # cuda_runtime.h
      libcublas
    ];
    postBuild = ''
      ln -s $out/lib $out/lib64
    '';
  };
in
stdenv.mkDerivation {
  inherit pname version;

  src = fetchFromGitHub {
    owner = "NVIDIA";
    repo = "thrust";
    rev = version;
    fetchSubmodules = true;
    hash = "sha256-/EyznxWKuHuvHNjq+SQg27IaRbtkjXR2zlo2YgCWmUQ=";
  };

  # NVIDIA's "compiler hacks" seem like work-arounds for legacy toolchains and
  # cause us errors such as:
  # > Thrust's test harness uses CMAKE_CXX_COMPILER for the CUDA host compiler.
  # > Refusing to overwrite specified CMAKE_CUDA_HOST_COMPILER
  # So we un-fix cmake after them:
  postPatch = ''
    echo > cmake/ThrustCompilerHacks.cmake
  '';

  buildInputs = lib.optionals tbbSupport [ tbb ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ] ++ lib.optionals cudaSupport [
    # Goes in native build inputs because thrust looks for headers
    # in a path relative to nvcc...
    cudaJoined
  ];

  cmakeFlags = [
    "-DTHRUST_INCLUDE_CUB_CMAKE=${if cudaSupport then "ON" else "OFF"}"
    "-DTHRUST_DEVICE_SYSTEM=${deviceSystem}"
    "-DTHRUST_HOST_SYSTEM=${hostSystem}"
    "-DTHRUST_AUTO_DETECT_COMPUTE_ARCHS=OFF"
    "-DTHRUST_DISABLE_ARCH_BY_DEFAULT=ON"
  ] ++ lib.optionals cudaFlags.enableForwardCompat [
    "-DTHRUST_ENABLE_COMPUTE_FUTURE=ON"
  ] ++ map (sm: "THRUST_ENABLE_COMPUTE_${sm}") cudaCapabilities;

  passthru = {
    inherit cudaSupport cudaPackages cudaJoined;
  };

  meta = with lib; {
    description = "A high-level C++ parallel algorithms library that builds on top of CUDA, TBB, OpenMP, etc";
    homepage = "https://github.com/NVIDIA/thrust";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
