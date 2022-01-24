{ callPackage, fetchpatch, ... } @ args:

callPackage ./generic.nix (args // {
  baseVersion = "2.18";
  revision = "1";
  sha256 = "0adf53drhk1hlpfih0175c9081bqpclw6p2afn51cmx849ib9izq";
  postPatch = ''
    sed -e 's@lang_flags "@&--std=c++11 @' -i src/build-data/cc/{gcc,clang}.txt
  '';
  extraPatches = [
    (fetchpatch {
      name = "CVE-2021-40529.patch";
      url = "https://github.com/randombit/botan/commit/9a23e4e3bc3966340531f2ff608fa9d33b5185a2.patch";
      sha256 = "1ax1n2l9zh0hk35vkkywgkhzpdk76xb9apz2wm3h9kjvjs9acr3y";
      # our source tarball doesn't include the tests
      excludes = [ "src/tests/*" ];
    })
  ];
})
