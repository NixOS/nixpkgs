# NOTE: Order matters! Put the oldest version first, and the newest version last.
# NOTE: Make sure the supportedGpuTargets are in order of oldest to newest.
#   You can update the supportedGpuTargets by looking at the CMakeLists.txt file.
#   HIP is here: https://bitbucket.org/icl/magma/src/f4ec79e2c13a2347eff8a77a3be6f83bc2daec20/CMakeLists.txt#lines-386
#   CUDA works around magma's wrappers and uses FindCUDAToolkit directly
[
  {
    version = "2.6.2";
    hash = "sha256-dbVU2rAJA+LRC5cskT5Q5/iMvGLzrkMrWghsfk7aCnE=";
    supportedGpuTargets = [
      "700"
      "701"
      "702"
      "703"
      "704"
      "705"
      "801"
      "802"
      "803"
      "805"
      "810"
      "900"
      "902"
      "904"
      "906"
      "908"
      "909"
      "90c"
      "1010"
      "1011"
      "1012"
      "1030"
      "1031"
      "1032"
      "1033"
    ];
  }
  {
    version = "2.7.2";
    hash = "sha256-cpvBpw5RinQi/no6VFN6R0EDWne+M0n2bqxcNiV21WA=";
    supportedGpuTargets = [
      "700"
      "701"
      "702"
      "703"
      "704"
      "705"
      "801"
      "802"
      "803"
      "805"
      "810"
      "900"
      "902"
      "904"
      "906"
      "908"
      "909"
      "90c"
      "1010"
      "1011"
      "1012"
      "1030"
      "1031"
      "1032"
      "1033"
    ];
  }
]
