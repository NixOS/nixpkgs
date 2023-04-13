final: prev: let
  ### Cuda Toolkit

  # Function to build the class cudatoolkit package
  buildCudaToolkitPackage = final.callPackage ./common.nix;

  # Version info for the classic cudatoolkit packages that contain everything that is in redist.
  cudatoolkitVersions = final.lib.importTOML ./versions.toml;

  finalVersion = cudatoolkitVersions.${final.cudaVersion};

  # Exposed as cudaPackages.backendStdenv.
  # This is what nvcc uses as a backend,
  # and it has to be an officially supported one (e.g. gcc11 for cuda11).
  #
  # It, however, propagates current stdenv's libstdc++ to avoid "GLIBCXX_* not found errors"
  # when linked with other C++ libraries.
  # E.g. for cudaPackages_11_8 we use gcc11 with gcc12's libstdc++
  # Cf. https://github.com/NixOS/nixpkgs/pull/218265 for context
  backendStdenv = final.callPackage ./stdenv.nix {
    # We use buildPackages (= pkgsBuildHost) because we look for a gcc that
    # runs on our build platform, and that produces executables for the host
    # platform (= platform on which we deploy and run the downstream packages).
    # The target platform of buildPackages.gcc is our host platform, so its
    # .lib output should be the libstdc++ we want to be writing in the runpaths
    # Cf. https://github.com/NixOS/nixpkgs/pull/225661#discussion_r1164564576
    nixpkgsCompatibleLibstdcxx = final.pkgs.buildPackages.gcc.cc.lib;
    nvccCompatibleCC = final.pkgs.buildPackages."${finalVersion.gcc}".cc;
  };

  ### Add classic cudatoolkit package
  cudatoolkit =
    let
      attrs = builtins.removeAttrs finalVersion [ "gcc" ];
      attrs' = attrs // { inherit backendStdenv; };
    in
    buildCudaToolkitPackage attrs';

  cudaFlags = final.callPackage ./flags.nix {};

in
{
  inherit
    backendStdenv
    cudatoolkit
    cudaFlags;
}
