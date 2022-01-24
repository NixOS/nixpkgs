import ./generic.nix {
  majorVersion = "8.2";
  minorVersion = "0";
  sourceSha256 = "1fspgp8k0myr6p2a6wkc21ldcswb4bvmb484m12mxgk1a9vxrhrl";
  patchesToFetch = [{
   url = "https://gitlab.kitware.com/vtk/vtk/-/commit/257b9d7b18d5f3db3fe099dc18f230e23f7dfbab.diff";
   sha256 = "0qdahp4f4gcaznr28j06d5fyxiis774ys0p335aazf7h51zb8rzy";
  }
  {
    url = "https://gitweb.gentoo.org/repo/gentoo.git/plain/sci-libs/vtk/files/vtk-8.2.0-gcc-10.patch?id=c4256f68d3589570443075eccbbafacf661f785f";
    sha256 = "sha256:0bpwrdfmi15grsg4jy7bzj2z6511a0c160cmw5lsi65aabyh7cl5";
  }
  {
    url = "https://gitlab.kitware.com/vtk/vtk/-/merge_requests/6943.diff";
    sha256 = "sha256:1nzdw3f6bsri04y528zj2klqkb9p8s4lnl9g5zvm119m1cmyhn04";
  }
  ];
}
