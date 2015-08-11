{ callPackage, apacheHttpd }:
callPackage ./generic.nix {
  phpVersion = "5.4.44";
  sha = "0vc5lf0yjk1fs7inri76mh0lrcmq32ji4m6yqdmg7314x5f9xmcd";
  apacheHttpd = apacheHttpd;
}
