{ lib
, config
, fetchFromGitHub
, stdenv
, cmake
, pkg-config
, cudaPackages
, symlinkJoin
, tbb
  # Upstream defaults:
, hostSystem ? "CPP"
, deviceSystem ? if config.cudaSupport or false then "CUDA" else "CPP"
}:

assert builtins.elem deviceSystem [ "CPP" "OMP" "TBB" "CUDA" ];
assert builtins.elem hostSystem [ "CPP" "OMP" "TBB" ];

let
  pname = "nvidia-thrust";
  version = "1.16.0";

  tbbSupport = builtins.elem "TBB" [ deviceSystem hostSystem ];
  cudaSupport = deviceSystem == "CUDA";

  # TODO: Would like to use this:
  cudaJoined = symlinkJoin {
    name = "cuda-packages-unsplit";
    paths = with cudaPackages; [
      cuda_nvcc
      cuda_cudart # cuda_runtime.h
      libcublas
    ];
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

  buildInputs = lib.optionals tbbSupport [ tbb ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ] ++ lib.optionals cudaSupport [
    # Goes in native build inputs because thrust looks for headers
    # in a path relative to nvcc...

    # Works when build=host, but we only support
    # cuda on x86_64 anyway

    # TODO: but instead using this
    # cudaJoined
    cudaPackages.cudatoolkit
  ];

  cmakeFlags = [
    "-DTHRUST_INCLUDE_CUB_CMAKE=${if cudaSupport then "ON" else "OFF"}"
    "-DTHRUST_DEVICE_SYSTEM=${deviceSystem}"
    "-DTHRUST_HOST_SYSTEM=${hostSystem}"
  ];

  passthru = {
    inherit cudaSupport cudaPackages;
  };

  meta = with lib; {
    description = ''
      A high-level C++ parallel algorithms library
      that builds on top of CUDA, TBB, OpenMP, etc.
    '';
    homepage = "https://github.com/NVIDIA/thrust";
    license = licenses.asl20;
    platforms = platforms.unix;
    maintainers = with maintainers; [ SomeoneSerge ];
  };
}
