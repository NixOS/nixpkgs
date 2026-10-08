{ buildRedist }:
buildRedist {
  redistName = "cuda";
  pname = "cuda_tileiras";

  outputs = [
    "out"
  ];

  meta = {
    description = "CUDA TileIR Assembler";
    longDescription = ''
      NVIDIA® CUDA® Tile is a tile-based GPU programming model that targets
      portability for NVIDIA Tensor Cores. CUDA Tile unlocks peak GPU
      performance with a programming model that simplifies the creation of
      optimized, tile-based kernels across NVIDIA platforms.

      Tile IR offers a high-level yet explicit target for code generation that
      abstracts away generation-specific hardware details while exposing the
      massive parallelism of the GPU for next-generation compute frameworks in
      a stable and versioned manner.
    '';
    homepage = "https://developer.nvidia.com/cuda/tile";
  };
}
