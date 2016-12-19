{ stdenv, fetchurl, fetchpatch, cmake, boost, gtest }:

stdenv.mkDerivation rec {
  name = "lucene++-${version}";
  version = "3.0.6";

  src = fetchurl {
    url = "https://github.com/luceneplusplus/LucenePlusPlus/"
        + "archive/rel_${version}.tar.gz";
    sha256 = "068msvh05gsbfj1wwdqj698kxxfjdqy8zb6pqvail3ayjfj94w1y";
  };

  patches = let
    baseurl = "https://github.com/luceneplusplus/LucenePlusPlus";
  in [
    (fetchpatch {
      url = "${baseurl}/pull/62.diff";
      sha256 = "0v314877mjb0hljg4mcqi317m1p1v27rgsgf5wdr9swix43vmhgw";
    })
    (fetchpatch {
      url = "${baseurl}/commit/994f03cf736229044a168835ae7387696041658f.diff";
      sha256 = "0fcm5b87nxw062wjd7b4qrfcwsyblmcw19s64004pklj9grk30zz";
    })
  ];

  postPatch = ''
    sed -i -e '/Subversion *REQUIRED/d' \
           -e '/include.*CMakeExternal/d' \
           CMakeLists.txt
    # not using -f because we want it to fail for the next release
    rm CMakeExternal.txt
  '';

  cmakeFlags = [ "-DGTEST_INCLUDE_DIR=${gtest}/include" ];
  buildInputs = [ cmake boost gtest ];

  enableParallelBuilding = true;
  doCheck = true;
  checkTarget = "test";

  meta = {
    description = "C++ port of the popular Java Lucene search engine";
    homepage = "https://github.com/luceneplusplus/LucenePlusPlus";
    license = with stdenv.lib.licenses; [ asl20 lgpl3Plus ];
    platforms = stdenv.lib.platforms.linux;
  };
}
