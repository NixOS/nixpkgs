{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "2.18";
  revision = "0";
  sha256 = "09z3fy31q1pvnvpy4fswrsl2aq8ksl94lbh5rl7b6nqc3qp8ar6c";
  postPatch = ''
    sed -e 's@lang_flags "@&--std=c++11 @' -i src/build-data/cc/{gcc,clang}.txt
  '';
})
