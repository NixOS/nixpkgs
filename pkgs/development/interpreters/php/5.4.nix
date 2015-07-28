{ callPackage, apacheHttpd }:
callPackage ./generic.nix {
  phpVersion = "5.4.43";
  sha = "0sydirpwg150wxsjrpp3m38564832wviglmsylhbbl8an17p5mr5";
  apacheHttpd = apacheHttpd;
}
