{ stdenv, callPackage, fetchpatch
# Darwin frameworks
, Cocoa, CoreMedia, VideoToolbox
, ...
}@args:

callPackage ./generic.nix (args // rec {
  version = "${branch}";
  branch = "4.1.2";
  sha256 = "00yzwc2g97h8ws0haz1p0ahaavhgrbha6xjdc53a5vyfy3zyy3i0";
  darwinFrameworks = [ Cocoa CoreMedia VideoToolbox ];
})
