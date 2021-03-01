{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "2.17";
  revision = "2";
  sha256 = "0v0yiq0qxcrsn5b34j6bz8i6pds8dih2ds90ylmy1msm5gz7vqpb";
  postPatch = ''
    sed -e 's@lang_flags "@&--std=c++11 @' -i src/build-data/cc/{gcc,clang}.txt
  '';
})
