# Packages which have been deprecated or removed from cudaPackages
{ lib }:
let
  mkRenamed =
    oldName:
    { path, package }:
    lib.warn "cudaPackages.${oldName} is deprecated, use ${path} instead" package;
in
final: _:
builtins.mapAttrs mkRenamed {
  # A comment to prevent empty { } from collapsing into a single line

  # NVIDIA renamed cuda_cccl to cccl in CUDA 13.3.
  # For the sake of simplicity, we updated the attrname tree-wide, accross all cudaPackages version.
  cuda_cccl = {
    path = "cccl";
    package = final.cccl;
  };
}
