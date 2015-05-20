{ callPackage, apacheHttpd }:
callPackage ./generic.nix {
  phpVersion = "5.4.41";
  sha = "0wl27f5z6vymajm2bzfp440zsp1jdxqn71avryiq1zw029db9i2v";
  apacheHttpd = apacheHttpd;
}
