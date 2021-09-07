{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "2.18";
  revision = "1";
  sha256 = "0adf53drhk1hlpfih0175c9081bqpclw6p2afn51cmx849ib9izq";
  postPatch = ''
    sed -e 's@lang_flags "@&--std=c++11 @' -i src/build-data/cc/{gcc,clang}.txt
  '';
})
