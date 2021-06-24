{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "2.17";
  revision = "3";
  sha256 = "121vn1aryk36cpks70kk4c4cfic5g0qs82bf92xap9258ijkn4kr";
  postPatch = ''
    sed -e 's@lang_flags "@&--std=c++11 @' -i src/build-data/cc/{gcc,clang}.txt
  '';
})
