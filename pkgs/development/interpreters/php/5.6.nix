{ callPackage, apacheHttpd  }:
callPackage ./generic.nix {
  phpVersion = "5.6.6";
  sha = "0k5vml94p5809bk2d5a8lhzf3h7f1xgs75b9qy6ikj70cndmqqh9";
  apacheHttpd = apacheHttpd;
}
