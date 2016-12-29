{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "1.10";
  revision = "14";
  sha256 = "072czy26vfjcqjww4qccsd29fzkb6mb8czamr4x76rdi9lwhpv8h";
  extraConfigureFlags = "--with-gnump";
  postPatch = ''
    sed -e 's@lang_flags "@&--std=c++11 @' -i src/build-data/cc/{gcc,clang}.txt
  '';
})
