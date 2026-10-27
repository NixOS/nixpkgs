{ callPackage, cudaOlder }:
# From CUDA 12.9, the redistributable contains only the NVTX v3 headers and libnvtx3interop, which are built from
# source. Earlier releases also contain the NVTX v2 headers and library (libnvToolsExt), which are not open source.
if cudaOlder "12.9" then callPackage ./redist.nix { } else callPackage ./source.nix { }
