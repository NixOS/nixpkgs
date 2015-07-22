{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "${branch}.3";
  branch = "2.6";
  sha256 = "1yqc3vm1xrwf866q262qd4nr9d6ifp4gg183pjdc4sl9np0rissr";
})
