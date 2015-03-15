{ callPackage, apacheHttpd }:
callPackage ./makePhpDerivation.nix {
  phpVersion = "5.4.39";
  sha = "0znpd6pgri5vah4j4wwamhqc60awila43bhh699p973hir9pdsvw";
  apacheHttpd = apacheHttpd;
}
