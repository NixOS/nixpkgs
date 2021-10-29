{ lib
, stdenv
, fetchFromGitHub
, abseil-cpp
, c-ares
, cmake
, crc32c
, curl
, grpc
, gbenchmark
, gtest
, ninja
, nlohmann_json
, pkg-config
, protobuf
  # default list of APIs: https://github.com/googleapis/google-cloud-cpp/blob/v1.32.1/CMakeLists.txt#L173
, apis ? [ "*" ]
}:
let
  googleapisRev = "ed739492993c4a99629b6430affdd6c0fb59d435";
  googleapis = fetchFromGitHub {
    owner = "googleapis";
    repo = "googleapis";
    rev = googleapisRev;
    hash = "sha256:1xrnh77vb8hxmf1ywqsifzd39kylhbdyah0b0b9bm7nw0mnahssl";
  };
in
stdenv.mkDerivation rec {
  pname = "google-cloud-cpp";
  version = "1.32.1";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-cpp";
    rev = "v${version}";
    sha256 = "0g720sni70nlncv4spm4rlfykdkpjnv81axfz2jd1arpdajm0mg9";
  };

  postPatch = ''
    substituteInPlace external/googleapis/CMakeLists.txt \
      --replace "https://github.com/googleapis/googleapis/archive/${googleapisRev}.tar.gz" "file://${googleapis}"
  '';

  nativeBuildInputs = [
    cmake
    ninja
    pkg-config
  ];

  buildInputs = [
    abseil-cpp
    c-ares
    crc32c
    curl
    grpc
    gbenchmark
    gtest
    nlohmann_json
    protobuf
  ];

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS:BOOL=ON"
    "-DBUILD_TESTING:BOOL=ON"
    "-DGOOGLE_CLOUD_CPP_ENABLE_EXAMPLES:BOOL=OFF"
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
