{ callPackage, stdenv }:
{
  rocm = callPackage ./vship.nix { gpuBackend = "rocm"; };
  cuda = callPackage ./vship.nix { gpuBackend = "cuda"; };
}
