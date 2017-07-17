{ stdenv, fetchurl, fetchpatch, cmake, boost, gtest }:

stdenv.mkDerivation rec {
  name = "lucene++-${version}";
  version = "3.0.7";

  src = fetchurl {
    url = "https://github.com/luceneplusplus/LucenePlusPlus/"
        + "archive/rel_${version}.tar.gz";
    sha256 = "032yb35b381ifm7wb8cy2m3yndklnxyi5cgprjh48jqy641z46bc";
  };

  postPatch = ''
    sed -i -e '/Subversion *REQUIRED/d' \
           -e '/include.*CMakeExternal/d' \
           CMakeLists.txt
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
