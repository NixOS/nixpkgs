{ lib
, stdenv
, fetchFromGitHub
, c-ares
, cmake
, crc32c
, curl
, gbenchmark
, grpc
, gtest
, ninja
, nlohmann_json
, openssl
, pkg-config
, protobuf
  # default list of APIs: https://github.com/googleapis/google-cloud-cpp/blob/v1.32.1/CMakeLists.txt#L173
, apis ? [ "*" ]
, staticOnly ? stdenv.hostPlatform.isStatic
}:
let
  googleapisRev = "13d5b3f3f9412f38427c8ad48068f04ad1ee9808";
  googleapis = fetchFromGitHub {
    name = "googleapis-src";
    owner = "googleapis";
    repo = "googleapis";
    rev = googleapisRev;
    hash = "sha256-SiU7N1EQ/7LWhUwgf4c0CBfUzNGiLe4sSbbJmJF3sao=";
  };
  excludedTests = builtins.fromTOML (builtins.readFile ./skipped_tests.toml);
in
stdenv.mkDerivation rec {
  pname = "google-cloud-cpp";
  version = "2.4.0";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-cpp";
    rev = "v${version}";
    sha256 = "sha256-o8aURM8fvxn0FZjuqJGclq9Brss8LOFZzD0FV2j/lUc=";
  };

  postPatch = ''
    substituteInPlace external/googleapis/CMakeLists.txt \
      --replace "https://github.com/googleapis/googleapis/archive/\''${_GOOGLE_CLOUD_CPP_GOOGLEAPIS_COMMIT_SHA}.tar.gz" "file://${googleapis}"
    sed -i '/https:\/\/storage.googleapis.com\/cloud-cpp-community-archive\/com_google_googleapis/d' external/googleapis/CMakeLists.txt
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ] ++ lib.optionals (!doInstallCheck) [
    # enable these dependencies when doInstallCheck is false because we're
    # unconditionally building tests and benchmarks
    #
    # when doInstallCheck is true, these deps are added to installCheckInputs
    gbenchmark
    gtest
  ];

  buildInputs = [
    c-ares
    crc32c
    (curl.override { inherit openssl; })
    grpc
    nlohmann_json
    openssl
    protobuf
  ];

  doInstallCheck = true;

  preInstallCheck =
    let
      # These paths are added to (DY)LD_LIBRARY_PATH because they contain
      # testing-only shared libraries that do not need to be installed, but
      # need to be loadable by the test executables.
      #
      # Setting (DY)LD_LIBRARY_PATH is only necessary when building shared libraries.
      additionalLibraryPaths = [
        "$PWD/google/cloud/bigtable"
        "$PWD/google/cloud/bigtable/benchmarks"
        "$PWD/google/cloud/pubsub"
        "$PWD/google/cloud/spanner"
        "$PWD/google/cloud/spanner/benchmarks"
        "$PWD/google/cloud/storage"
        "$PWD/google/cloud/storage/benchmarks"
        "$PWD/google/cloud/testing_util"
      ];
      ldLibraryPathName = "${lib.optionalString stdenv.isDarwin "DY"}LD_LIBRARY_PATH";
    in
    lib.optionalString doInstallCheck (
      lib.optionalString (!staticOnly) ''
        export ${ldLibraryPathName}=${lib.concatStringsSep ":" additionalLibraryPaths}
      '' + ''
        export GTEST_FILTER="-${lib.concatStringsSep ":" excludedTests.cases}"
      ''
    );

  installCheckPhase = lib.optionalString doInstallCheck ''
    runHook preInstallCheck

    # disable tests that contact the internet
    ctest --exclude-regex '^(${lib.concatStringsSep "|" excludedTests.whole})'

    runHook postInstallCheck
  '';

  installCheckInputs = lib.optionals doInstallCheck [
    gbenchmark
    gtest
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS:BOOL=${if staticOnly then "OFF" else "ON"}"
    # unconditionally build tests to catch linker errors as early as possible
    # this adds a good chunk of time to the build
    "-DBUILD_TESTING:BOOL=ON"
    "-DGOOGLE_CLOUD_CPP_ENABLE_EXAMPLES:BOOL=OFF"
    "-DCMAKE_CXX_STANDARD=${grpc.cxxStandard}"
  ] ++ lib.optionals (apis != [ "*" ]) [
    "-DGOOGLE_CLOUD_CPP_ENABLE=${lib.concatStringsSep ";" apis}"
  ];

  meta = with lib; {
    license = with licenses; [ asl20 ];
    homepage = "https://github.com/googleapis/google-cloud-cpp";
    description = "C++ Idiomatic Clients for Google Cloud Platform services";
    maintainers = with maintainers; [ cpcloud ];
  };
}
