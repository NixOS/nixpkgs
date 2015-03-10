{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "${branch}.13";
  branch = "2.2";
  sha256 = "1vva8ffwxi3rg44byy09qlbiqrrd1h4rmsl5b1mbmvzvwl1lq1l0";
})
