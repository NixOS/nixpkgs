{ callPackage, ... } @ args:

callPackage ./generic-v3-cmake.nix ({
  version = "3.24.3";
  sha256 = "sha256-wXGQW/o674DeLXX2IlyZskl5OrBcSRptOMoJqLQGm94=";
} // args)
