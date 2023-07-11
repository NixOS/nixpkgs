{ callPackage, fetchpatch, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "2.19";
  revision = "3";
  sha256 = "sha256-2uBH85nFpH8IfbXT2dno8RrkmF0UySjXHaGv+AGALVU=";
  postPatch = ''
    sed -e 's@lang_flags "@&--std=c++11 @' -i src/build-data/cc/{gcc,clang}.txt
  '';
})
