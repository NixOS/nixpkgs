import ./generic.nix {
  majorVersion = "8.2";
  minorVersion = "0";
  sourceSha256 = "1fspgp8k0myr6p2a6wkc21ldcswb4bvmb484m12mxgk1a9vxrhrl";
  patchesToFetch = [{
   url = "https://gitlab.kitware.com/vtk/vtk/-/commit/257b9d7b18d5f3db3fe099dc18f230e23f7dfbab.diff";
   sha256 = "0qdahp4f4gcaznr28j06d5fyxiis774ys0p335aazf7h51zb8rzy";
  }];
}
