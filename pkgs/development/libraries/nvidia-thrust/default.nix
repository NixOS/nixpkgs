{ lib
, config
, fetchFromGitHub
, stdenv
, cmake
, pkg-config
, cudaSupport ? config.cudaSupport or false
, cudaPackages
, symlinkJoin
, enableOpenmp ? true
, enableTbb ? false
, tbb
, hostSystem ? "CPP"
, deviceSystem ? let
    devices = lib.optional cudaSupport "CUDA"
      ++ lib.optional enableTbb "TBB"
      ++ lib.optional enableOpenmp "OMP"
      ++ [ "CPP" ];
  in
  builtins.head devices
}:

assert builtins.elem deviceSystem [ "CPP" "OMP" "TBB" "CUDA" ];
assert builtins.elem hostSystem [ "CPP" "OMP" "TBB" ];
assert (deviceSystem == "CUDA") -> cudaSupport;
assert (builtins.elem "TBB" [ deviceSystem hostSystem ]) -> enableTbb;
assert (builtins.elem "OMP" [ deviceSystem hostSystem ]) -> enableOpenmp;

let
  pname = "nvidia-thrust";
  version = "1.16.0";

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

  buildInputs = lib.optional enableTbb tbb;

  nativeBuildInputs = [
    cmake
    pkg-config
  ] ++ lib.optionals cudaSupport [
    # goes in native build inputs because thrust looks for headers
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
