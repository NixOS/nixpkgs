{ lib
, stdenv
, fetchFromGitHub
, cmake
, doxygen
, graphviz
, gtest
, valgrind
, buildTests ? !stdenv.hostPlatform.isStatic && !stdenv.isDarwin
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rapidjson";
  version = "unstable-2024-04-09";

  outputs = [
    "out"
    "doc"
  ];

  src = fetchFromGitHub {
    owner = "Tencent";
    repo = "rapidjson";
    rev = "ab1842a2dae061284c0a62dca1cc6d5e7e37e346";
    hash = "sha256-kAGVJfDHEUV2qNR1LpnWq3XKBJy4hD3Swh6LX5shJpM=";
  };

  patches = lib.optionals buildTests [
    ./0000-unstable-use-nixpkgs-gtest.patch
    # https://github.com/Tencent/rapidjson/issues/2214
    ./0001-unstable-valgrind-suppress-failures.patch
  ];

  nativeBuildInputs = [
    cmake
    doxygen
    graphviz
  ];

  cmakeFlags = [
    (lib.cmakeBool "RAPIDJSON_BUILD_DOC" true)
    (lib.cmakeBool "RAPIDJSON_BUILD_TESTS" buildTests)
    (lib.cmakeBool "RAPIDJSON_BUILD_EXAMPLES" true)
    # gtest 1.13+ requires C++14 or later.
    (lib.cmakeBool "RAPIDJSON_BUILD_CXX11" false)
    (lib.cmakeBool "RAPIDJSON_BUILD_CXX17" true)
  ] ++ lib.optionals buildTests [
    (lib.cmakeFeature "GTEST_INCLUDE_DIR" "${lib.getDev gtest}")
  ];

  doCheck = buildTests;

  nativeCheckInputs = [
    gtest
    valgrind
  ];

  meta = with lib; {
    description = "Fast JSON parser/generator for C++ with both SAX/DOM style API";
    homepage = "http://rapidjson.org/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dotlambda Madouura tobim ];
  };
})
