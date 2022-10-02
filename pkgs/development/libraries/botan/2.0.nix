{ callPackage, fetchpatch, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "2.19";
  revision = "2";
  sha256 = "sha256-OvXxdhXGtc2Lgy0mn7bLTVTsZPnrCd2/Gt1Qk5QbTXU=";
  postPatch = ''
    sed -e 's@lang_flags "@&--std=c++11 @' -i src/build-data/cc/{gcc,clang}.txt
  '';
})
