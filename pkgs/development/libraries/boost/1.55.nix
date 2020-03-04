{ callPackage, fetchurl, ... } @ args:

callPackage ./generic.nix (args // {
  version = "1.55.0";

  patches = [ ./clang-math.patch ./clang-math-2.patch ./gcc-5.patch ];

  src = fetchurl {
    url = "mirror://sourceforge/boost/boost_1_55_0.tar.bz2";
    sha256 = "0lkv5dzssbl5fmh2nkaszi8x9qbj80pr4acf9i26sj3rvlih1w7z";
  };
})
