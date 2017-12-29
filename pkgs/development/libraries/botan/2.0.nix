{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "2.3";
  revision = "0";
  sha256 = "0z6lwv28hxnfkhd4s03cb4cdm1621bsswc2h88z4qslqwpz71y9r";
  postPatch = ''
    sed -e 's@lang_flags "@&--std=c++11 @' -i src/build-data/cc/{gcc,clang}.txt
  '';
})
