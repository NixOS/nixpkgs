{ callPackage
# Darwin frameworks
, Cocoa, CoreMedia
, ...
}@args:

callPackage ./generic.nix (args // rec {
  version = "${branch}.2";
  branch = "3.1";
  sha256 = "1xvh1c8nlws0wx6b7yl1pvkybgzaj5585h1r6z1gzhck1f0qvsv2";
  darwinFrameworks = [ Cocoa CoreMedia ];
})
