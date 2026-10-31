{
  lib,
  stdenv,
  fetchFromGitHub,
  cmake,
  boost,
  gtest,
  json11,
  jsoncpp,
  nlohmann_json,
  picojson,
  rapidjson,
  yaml-cpp,
  nix-update-script,
}:

let
  # The official JSON-Schema-Test-Suite fixtures that tests/test_validator.cpp
  # reads straight off disk, pinned to the exact submodule commit recorded by
  # the v1.1.3 tag.
  jsonSchemaTestSuiteSrc = fetchFromGitHub {
    owner = "json-schema-org";
    repo = "JSON-Schema-Test-Suite";
    rev = "7ab81c077a6ff1bcf8d3c35b7209e1b402d465de";
    hash = "sha256-7nGYkjQo6oq2oKd8ikyvxUrLAmRIHtl86mYM/2kny54=";
  };
in
stdenv.mkDerivation (finalAttrs: {
  pname = "valijson";
  version = "1.1.3";

  strictDeps = true;
  __structuredAttrs = true;
  separateDebugInfo = true;

  src = fetchFromGitHub {
    owner = "tristanpenman";
    repo = "valijson";
    rev = "v${finalAttrs.version}";
    hash = "sha256-1bZPc+oSaKy7OuHqXDbswbVhNPm6273IeCh/Q48STZI=";
  };

  patches = [
    # QtJsonAdapter's isInteger()/getInteger() use QJsonValue::toInt()
    # (32-bit), so integral values outside int32 range (e.g. a uint32 CRC)
    # either fail "type": "integer" schema checks or get silently truncated.
    # Still present upstream as of this release. TODO: Upstream.
    ./qtjson-adapter-int64.patch
    # test_suite otherwise builds jsoncpp/yaml-cpp/json11 from vendored
    # submodule sources and vendors its own gtest/nlohmann-json/rapidjson via
    # thirdparty/ instead of find_package(); point it at the nixpkgs
    # packages so the test suite doesn't need those submodules at all.
    ./use-nixpkgs-test-deps.patch
  ];

  postPatch = lib.optionalString finalAttrs.finalPackage.doCheck ''
    mkdir -p thirdparty/JSON-Schema-Test-Suite
    cp -r --no-preserve=mode,ownership ${jsonSchemaTestSuiteSrc}/. thirdparty/JSON-Schema-Test-Suite/
  '';

  nativeBuildInputs = [ cmake ];

  doCheck = true;

  cmakeFlags = [
    (lib.cmakeBool "valijson_BUILD_TESTS" finalAttrs.finalPackage.doCheck)
  ];

  # boost is already cheap/ubiquitous in nixpkgs, so pull in the
  # property_tree and boost.json adapter tests too. Poco and Qt are much
  # heavier dependencies for what they'd add (one adapter test each), so
  # those stay unexercised; find_package() for both just fails quietly
  # (valijson_REQUIRE_ALL_ADAPTER_TESTS defaults off) and the test suite
  # skips their adapters.
  checkInputs = [
    boost
    gtest
    json11
    jsoncpp
    nlohmann_json
    picojson
    rapidjson
    yaml-cpp
  ];

  # Upstream's test_suite/test_rapidjson_crt_allocator executables aren't
  # wired up to CTest (no enable_testing()/add_test() anywhere), so run them
  # directly.
  checkPhase = ''
    runHook preCheck
    ./test_suite
    ./test_rapidjson_crt_allocator
    runHook postCheck
  '';

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Header-only C++ library for JSON Schema validation, with support for many popular parsers";
    homepage = "https://github.com/tristanpenman/valijson";
    license = lib.licenses.bsd2;
    platforms = lib.platforms.all;
    maintainers = with lib.maintainers; [ pandapip1 ];
  };
})
