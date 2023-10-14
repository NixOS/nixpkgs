{ callPackage, ... } @ args:

callPackage ./generic.nix ({
  version = "24.3";
  hash = "sha256-wXGQW/o674DeLXX2IlyZskl5OrBcSRptOMoJqLQGm94=";
} // args)
