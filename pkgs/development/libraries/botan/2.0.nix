{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  version = "2.11.0";
  sha256 = "19pqpxbdrjyglbx9c0z8m98vj4bbidn66pkysjabyqx71596r2ah";
  postPatch = ''
    sed -e 's@lang_flags "@&--std=c++11 @' -i src/build-data/cc/{gcc,clang}.txt
  '';
})
