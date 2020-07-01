{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "2.7";
  revision = "0";
  sha256 = "142aqabwc266jxn8wrp0f1ffrmcvdxwvyh8frb38hx9iaqazjbg4";
  postPatch = ''
    sed -e 's@lang_flags "@&--std=c++11 @' -i src/build-data/cc/{gcc,clang}.txt
  '';
})
