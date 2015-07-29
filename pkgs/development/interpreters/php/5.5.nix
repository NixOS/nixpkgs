{ callPackage, apacheHttpd  }:
callPackage ./generic.nix {
  phpVersion = "5.5.27";
  sha = "0w0zgqria3i3mrp03p9m0613xlaj3vsw9girmslngjn06jjwdd64";
  apacheHttpd = apacheHttpd;
}
