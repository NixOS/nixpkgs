{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  eigen,
  rapidjson,
  spdlog,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "vowpal-wabbit";
  version = "9.10.0";

  src = fetchFromGitHub {
    owner = "VowpalWabbit";
    repo = "vowpal_wabbit";
    tag = version;
    hash = "sha256-HKxhEB4ph2tOWgvYngYTcv0OCMISj3KqZpP2zsEUPs0=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace-fail "set(VW_CXX_STANDARD 11)" "set(VW_CXX_STANDARD 14)"
    # Avoid duplicate add RapidJSON
    substituteInPlace ext_libs/ext_libs.cmake \
      --replace-fail "add_library(RapidJSON INTERFACE)" ""
  '';

  nativeBuildInputs = [ cmake ];

  buildInputs = [
    boost
    eigen
    rapidjson
    spdlog
    zlib
  ];

  cmakeFlags = [
    "-DVW_INSTALL=ON"
    "-DBUILD_JAVA=OFF"
    "-DBUILD_PYTHON=OFF"
    "-DRAPIDJSON_SYS_DEP=ON"
    "-DFMT_SYS_DEP=ON"
    "-DSPDLOG_SYS_DEP=ON"
    "-DVW_BOOST_MATH_SYS_DEP=ON"
    "-DVW_EIGEN_SYS_DEP=ON"
  ];

  meta = {
    description = "Machine learning system focused on online reinforcement learning";
    homepage = "https://github.com/VowpalWabbit/vowpal_wabbit/";
    license = lib.licenses.bsd3;
    longDescription = ''
      Machine learning system which pushes the frontier of machine learning with techniques such as online,
      hashing, allreduce, reductions, learning2search, active, and interactive and reinforcement learning
    '';
    maintainers = with lib.maintainers; [ jackgerrits ];
    platforms = lib.platforms.unix;
  };
}
