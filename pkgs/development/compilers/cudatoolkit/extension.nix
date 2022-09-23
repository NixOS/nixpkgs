final: prev: let
  ### Cuda Toolkit

  # Function to build the class cudatoolkit package
  buildCudaToolkitPackage = final.callPackage ./common.nix;

  # Version info for the classic cudatoolkit packages that contain everything that is in redist.
  cudatoolkitVersions = final.lib.importTOML ./versions.toml;

  ### Add classic cudatoolkit package
  cudatoolkit = buildCudaToolkitPackage ((attrs: attrs // { gcc = prev.pkgs.${attrs.gcc}; }) cudatoolkitVersions.${final.cudaVersion});

in {
  inherit cudatoolkit;
}
