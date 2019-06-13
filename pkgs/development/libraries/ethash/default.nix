{ stdenv, fetchFromGitHub, cmake, boost, cryptopp, opencl-headers, opencl-info,
  openmpi, ocl-icd, mesa, gbenchmark, gtest }:

stdenv.mkDerivation rec {
  pname = "ethash";
  version = "0.4.2";

  src =
    fetchFromGitHub {
      owner = "chfast";
      repo = "ethash";
      rev = "v${version}";
      sha256 = "0qiixvxbpl2gz7jh1qs8lmyk7wzv6ffnl7kckqgrpgm547nnn8zy";
    };

  nativeBuildInputs = [
    cmake
  ];

  buildInputs = [
    boost
    cryptopp
    opencl-headers
    opencl-info
    openmpi
    ocl-icd
    mesa
  ];

  checkInputs = [
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

  meta = with stdenv.lib; {
    description = "PoW algorithm for Ethereum 1.0 based on Dagger-Hashimoto";
    homepage = https://github.com/ethereum/ethash;
    platforms = [ "x86_64-linux" ];
    maintainers = with maintainers; [ nand0p ];
    license = licenses.asl20;
  };
}
