{callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "1.24.0";
  sha256 = "sha256-iXaBLCShGGAPb88HGiBgZjCmmv5MCr7jsN6lKOaCxYU=";
})
