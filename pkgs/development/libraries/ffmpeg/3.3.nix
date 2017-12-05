{ stdenv, callPackage
# Darwin frameworks
, Cocoa, CoreMedia
, ...
}@args:

callPackage ./generic.nix (args // rec {
  version = "${branch}";
  branch = "3.3.3";
  sha256 = "0wx421d7vp4nz8kgp0kg16sswikj8ff1pd18x9mmcbpmqy7sqs8h";
  darwinFrameworks = [ Cocoa CoreMedia ];
})
