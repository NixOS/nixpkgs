{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "2.9";
  revision = "0";
  sha256 = "06fiyalvc68p11qqh953azx2vrbav5vr00yvcfp67p9l4csn8m9h";
  postPatch = ''
    sed -e 's@lang_flags "@&--std=c++11 @' -i src/build-data/cc/{gcc,clang}.txt
  '';
})
