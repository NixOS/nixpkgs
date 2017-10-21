{ callPackage, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "1.10";
  revision = "15";
  sha256 = "1zkhmggzxjla2iwaiyrx5161yxckrzszmy9yghjlpnhg8zyqzk60";
  extraConfigureFlags = "--with-gnump";
  postPatch = ''
    sed -e 's@lang_flags "@&--std=c++11 @' -i src/build-data/cc/{gcc,clang}.txt
  '';
})
