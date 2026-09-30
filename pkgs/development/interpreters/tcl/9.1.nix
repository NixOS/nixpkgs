{
  callPackage,
  fetchzip,
  ...
}@args:

callPackage ./generic.nix (
  args
  // rec {
    release = "9.1";
    version = "${release}.0";

    # Note: when updating, the hash in pkgs/development/libraries/tk/9.1.nix must also be updated!

    src = fetchzip {
      url = "mirror://sourceforge/tcl/tcl${version}-src.tar.gz";
      hash = "sha256-iSJYZOQvzgvWA9/cD2jwOJsyuHIsryzw3fU+3bGH0cQ=";
    };
  }
)
