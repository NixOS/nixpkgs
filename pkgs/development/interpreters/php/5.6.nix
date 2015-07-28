{ callPackage, apacheHttpd  }:
callPackage ./generic.nix {
  phpVersion = "5.6.11";
  sha = "0riq0c8s8anb1nxvn3ljs7wdn811903sv7kl8ir2ck3n2q42csxx";
  apacheHttpd = apacheHttpd;
}
