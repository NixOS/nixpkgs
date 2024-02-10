{ lib
, stdenv
, fetchFromGitHub
, cmake
, doxygen
, graphviz
, gtest
, valgrind
# One of "11" or "17"; default in source is CXX 11
, cxxStandard ? "11"
, buildDocs ? true
, buildTests ? !stdenv.hostPlatform.isStatic && !stdenv.isDarwin
, buildExamples ? true
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "rapidjson";
  version = "unstable-2023-09-28";

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
    rev = "f9d53419e912910fd8fa57d5705fa41425428c35";
    hash = "sha256-rl7iy14jn1K2I5U2DrcZnoTQVEGEDKlxmdaOCF/3hfY=";
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
    (lib.cmakeBool "RAPIDJSON_BUILD_CXX11" (cxxStandard == "11"))
    (lib.cmakeBool "RAPIDJSON_BUILD_CXX17" (cxxStandard == "17"))
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
    maintainers = with maintainers; [ Madouura ];
    broken = (cxxStandard != "11" && cxxStandard != "17");
  };
})
