{ lib
, stdenv
, fetchFromGitHub
, cmake
, doxygen
, graphviz
, gtest
, valgrind
, buildDocs ? true
, buildTests ? !stdenv.hostPlatform.isStatic && !stdenv.isDarwin
, buildExamples ? true
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rapidjson";
  version = "unstable-2024-04-09";

  outputs = [
    "out"
  ] ++ lib.optionals buildDocs [
    "doc"
  ] ++ lib.optionals buildExamples [
    "example"
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
  ] ++ lib.optionals buildDocs [
    doxygen
    graphviz
  ];

  cmakeFlags = [
    (lib.cmakeBool "RAPIDJSON_BUILD_DOC" buildDocs)
    (lib.cmakeBool "RAPIDJSON_BUILD_TESTS" buildTests)
    (lib.cmakeBool "RAPIDJSON_BUILD_EXAMPLES" buildExamples)
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

  postInstall = lib.optionalString buildExamples ''
    mkdir -p $example/bin

    find bin -type f -executable \
      -not -name "perftest" \
      -not -name "unittest" \
      -exec cp -a {} $example/bin \;
  '';

  meta = with lib; {
    description = "Fast JSON parser/generator for C++ with both SAX/DOM style API";
    homepage = "http://rapidjson.org/";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ dotlambda Madouura tobim ];
  };
})
