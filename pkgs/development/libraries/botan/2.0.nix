{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "2.0";
  revision = "1";
  sha256 = "02sf6qghgs1lmprx715dnyll1rmqcjb9q6s50n20li8idlqysf51";
  postPatch = ''
    sed -e 's@lang_flags "@&--std=c++11 @' -i src/build-data/cc/{gcc,clang}.txt
  '';
})
