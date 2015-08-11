{ callPackage, apacheHttpd  }:
callPackage ./generic.nix {
  phpVersion = "5.6.12";
  sha = "0fl5r0lzav7icg97p7gkvbxk0xk2mh7i1r45dycjlyxgf91109vg";
  apacheHttpd = apacheHttpd;
}
