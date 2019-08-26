{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "2.11";
  revision = "0";
  sha256 = "0bwndamxfn34f7igkpmc8zs7xf52qwsjbykjm53583wxnff9cyra";
  postPatch = ''
    sed -e 's@lang_flags "@&--std=c++11 @' -i src/build-data/cc/{gcc,clang}.txt
  '';
})
