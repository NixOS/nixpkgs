{
  lib,
  stdenv,
  fetchFromGitHub,
  fetchpatch,
  cmake,
  boost,
  eigen,
  rapidjson,
  spdlog,
  zlib,
}:

stdenv.mkDerivation rec {
  pname = "vowpal-wabbit";
  version = "9.6.0";

  src = fetchFromGitHub {
    owner = "VowpalWabbit";
    repo = "vowpal_wabbit";
    rev = version;
    sha256 = "sha256-iSsxpeTRZjIhZaYBeoKLHl9j1aBIXWjONmAInmKvU/I=";
  };

  patches = [
    # Fix x86_64-linux build by adding missing include
    # https://github.com/VowpalWabbit/vowpal_wabbit/pull/4275
    (fetchpatch {
      url = "https://github.com/VowpalWabbit/vowpal_wabbit/commit/0cb410dfc885ca1ecafd1f8a962b481574fb3b82.patch";
      sha256 = "sha256-bX3eJ+vMTEMAo3EiESQTDryBP0h2GtnMa/Fz0rTeaNY=";
    })

    # Fix gcc-13 build:
    #   https://github.com/VowpalWabbit/vowpal_wabbit/pull/4657
    (fetchpatch {
      name = "gcc-13.patch";
      url = "https://github.com/VowpalWabbit/vowpal_wabbit/commit/a541d85a66088d2b74fa2562d32fecb68af33c58.patch";
      includes = [ "vowpalwabbit/core/include/vw/core/named_labels.h" ];
      hash = "sha256-JAuLDe5JtlE7/043RSIKM20Qr77rmuE0rVg/DGc95MY=";
    })
  ];

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

  meta = with lib; {
    description = "Machine learning system focused on online reinforcement learning";
    homepage = "https://github.com/VowpalWabbit/vowpal_wabbit/";
    license = licenses.bsd3;
    longDescription = ''
      Machine learning system which pushes the frontier of machine learning with techniques such as online,
      hashing, allreduce, reductions, learning2search, active, and interactive and reinforcement learning
    '';
    maintainers = with maintainers; [ jackgerrits ];
    platforms = platforms.unix;
  };
}
