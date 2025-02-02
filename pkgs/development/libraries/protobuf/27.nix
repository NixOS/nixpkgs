{ callPackage, ... } @ args:

callPackage ./generic.nix ({
  version = "27.1";
  hash = "sha256-9XOcjNm4k4VhQ/XagcVO2tXxp6bBdyuvrS7sNGy4wG0=";
} // args)
