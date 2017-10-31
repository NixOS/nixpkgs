{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "${branch}.12";
  branch = "1.2";
  sha256 = "0za9w87rk4x6wkjc6iaxqx2ihlsgj181ilfgxfjc54mdgxfcjfli";
  patches = [ ./vpxenc-1.2-libvpx-1.5.patch ];
})
