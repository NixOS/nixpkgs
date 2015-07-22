{ callPackage, apacheHttpd }:
callPackage ./generic.nix {
  phpVersion = "5.4.42";
  sha = "1yg03b6a88i7hg593m9zmmcm4kr59wdrhz9xk1frx9ps9gkb51b2";
  apacheHttpd = apacheHttpd;
}
