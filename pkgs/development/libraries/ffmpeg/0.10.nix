{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "${branch}.16";
  branch = "0.10";
  sha256 = "1l9z5yfp1vq4z2y4mh91707dhcn41c3pd505i0gvdzcdsp5j6y77";
  patches = [ ./vpxenc-0.10-libvpx-1.5.patch ];
})
