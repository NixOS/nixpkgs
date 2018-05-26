{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "2.6";
  revision = "0";
  sha256 = "1iawmymmnp5j2mcjj70slivn6bgg8gbpppldc1rjqw5sbdan3wn1";
  postPatch = ''
    sed -e 's@lang_flags "@&--std=c++11 @' -i src/build-data/cc/{gcc,clang}.txt
  '';
})
