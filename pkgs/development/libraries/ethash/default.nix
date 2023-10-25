{ lib, stdenv, fetchFromGitHub, cmake, gbenchmark, gtest }:

stdenv.mkDerivation rec {
  pname = "ethash";
  version = "0.8.0";

  src =
    fetchFromGitHub {
      owner = "chfast";
      repo = "ethash";
      rev = "v${version}";
      sha256 = "sha256-4SJk4niSpLPjymwTCD0kHOrqpMf+vE3J/O7DiffUSJ4=";
    };

  nativeBuildInputs = [
    cmake
  ];

  nativeCheckInputs = [
    gbenchmark
    gtest
  ];

  #preConfigure = ''
  #  sed -i 's/GTest::main//' test/unittests/CMakeLists.txt
  #  cat test/unittests/CMakeLists.txt
  #  ln -sfv ${gtest.src}/googletest gtest
  #'';

  # NOTE: disabling tests due to gtest issue
  cmakeFlags = [
    "-DHUNTER_ENABLED=OFF"
    "-DETHASH_BUILD_TESTS=OFF"
    #"-Dbenchmark_DIR=${gbenchmark}/lib/cmake/benchmark"
    #"-DGTest_DIR=${gtest.dev}/lib/cmake/GTest"
    #"-DGTest_DIR=${gtest.src}/googletest"
    #"-DCMAKE_PREFIX_PATH=${gtest.dev}/lib/cmake"
  ];

  meta = with lib; {
    description = "PoW algorithm for Ethereum 1.0 based on Dagger-Hashimoto";
    homepage = "https://github.com/ethereum/ethash";
    platforms = platforms.unix;
    maintainers = with maintainers; [ ];
    license = licenses.asl20;
  };
}
