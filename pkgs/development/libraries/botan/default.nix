{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "1.10.17";
  sha256 = "10807mx31vl1ql2bjq8j9mffx7yrh1rppy9k6nbhnc3b0z7nhwgm";
  extraConfigureFlags = "--with-gnump";
  postPatch = ''
    sed -e 's@lang_flags "@&--std=c++11 @' -i src/build-data/cc/{gcc,clang}.txt
  '';
})
