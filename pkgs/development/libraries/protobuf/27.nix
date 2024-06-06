{ callPackage, ... } @ args:

callPackage ./generic.nix ({
  version = "27.0";
  hash = "sha256-QVgDGyNTCSYU/rXTMcHUefUGVjwkkjnpq0Kq+eXK/bo=";
} // args)
