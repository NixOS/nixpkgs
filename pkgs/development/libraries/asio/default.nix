{callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "1.16.1";
  sha256 = "1333ca6lnsdck4fsgjpbqf4lagxsnbg9970wxlsrinmwvdvdnwg2";
})
