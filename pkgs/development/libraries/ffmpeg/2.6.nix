{ callPackage, ... } @ args:

callPackage ./generic.nix (args // rec {
  version = "${branch}.1";
  branch = "2.6";
  sha256 = "1hf77va46r8s05g5a5m7xx8b9vjzmqca0ajxsflsnbgf0s3kixm4";
})
