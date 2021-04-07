{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "1.10";
  revision = "17";
  sha256 = "04rnha712dd3sdb2q7k2yw45sf405jyigk7yrjfr6bwd9fvgyiv8";
  sourceExtension = "tgz";
  extraConfigureFlags = "--with-gnump";
  postPatch = ''
    sed -e 's@lang_flags "@&--std=c++11 @' -i src/build-data/cc/{gcc,clang}.txt
  '';
})
