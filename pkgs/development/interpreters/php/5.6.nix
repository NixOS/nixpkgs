{ callPackage, apacheHttpd  }:
callPackage ./generic.nix {
  phpVersion = "5.6.10";
  sha = "0iccgibmbc659z6dh6c58l1b7vnqly7al37fbs0l3si4qy0rqmqa";
  apacheHttpd = apacheHttpd;
}
