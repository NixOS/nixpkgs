{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "ursadb";
  version = "1.5.2";

  src = fetchFromGitHub {
    owner = "CERT-Polska";
    repo = "ursadb";
    tag = "v${finalAttrs.version}";
    hash = "sha256-UVfOImngYPB8UBQHzxwJM+dT3DWiT+7V+QGfUggjazI=";
    fetchSubmodules = true;
  };

  postPatch = ''
    substituteInPlace CMakeLists.txt \
      --replace "add_executable(ursadb_test src/Tests.cpp)" "" \
      --replace "target_link_libraries(ursadb_test ursa)" "" \
      --replace "target_enable_ipo(ursadb_test)" "" \
      --replace "target_clangformat_setup(ursadb_test)" "" \
      --replace 'target_include_directories(ursadb_test PUBLIC ${"$"}{CMAKE_SOURCE_DIR})' "" \
      --replace "ursadb_test" ""

    substituteInPlace extern/spdlog/CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.2)" "cmake_minimum_required(VERSION 3.10)"
    substituteInPlace extern/libzmq/CMakeLists.txt \
      --replace-fail "cmake_minimum_required(VERSION 3.0.2)" "cmake_minimum_required(VERSION 3.10)" \
      --replace-fail "cmake_minimum_required(VERSION 2.8.12)" "cmake_minimum_required(VERSION 3.10)"
  '';

  nativeBuildInputs = [
    cmake
  ];

  meta = with lib; {
    homepage = "https://github.com/CERT-Polska/ursadb";
    description = "Trigram database written in C++, suited for malware indexing";
    license = licenses.bsd3;
    maintainers = with maintainers; [ msm ];
    platforms = platforms.unix;
    broken = stdenv.hostPlatform.isDarwin || stdenv.hostPlatform.isAarch64;
  };
})
