{ lib, stdenv, fetchFromGitHub, cmake, boost, gtest }:

stdenv.mkDerivation rec {
  pname = "lucene++";
  version = "3.0.7";

  src = fetchFromGitHub {
    owner = "luceneplusplus";
    repo = "LucenePlusPlus";
    rev = "rel_${version}";
    sha256 = "06b37fly6l27zc6kbm93f6khfsv61w792j8xihfagpcm9cfz2zi1";
  };

  postPatch = ''
    sed -i -e '/Subversion *REQUIRED/d' \
           -e '/include.*CMakeExternal/d' \
           CMakeLists.txt
  '';

  cmakeFlags = [ "-DGTEST_INCLUDE_DIR=${gtest}/include" ];
  nativeBuildInputs = [ cmake ];
  buildInputs = [ boost gtest ];

  doCheck = true;
  checkTarget = "test";

  meta = {
    description = "C++ port of the popular Java Lucene search engine";
    homepage = "https://github.com/luceneplusplus/LucenePlusPlus";
    license = with lib.licenses; [ asl20 lgpl3Plus ];
    platforms = lib.platforms.linux;
  };
}
