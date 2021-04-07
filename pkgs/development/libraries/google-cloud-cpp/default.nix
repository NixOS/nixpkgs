{ lib
, stdenv
, clang-tools
, grpc
, curl
, cmake
, pkg-config
, fetchFromGitHub
, doxygen
, protobuf
, crc32c
, fetchurl
, openssl
, libnsl
}:
let
  googleapis = fetchFromGitHub {
    owner = "googleapis";
    repo = "googleapis";
    rev = "9c9f778aedde02f9826d2ae5d0f9c96409ba0f25";
    sha256 = "1gd3nwv8qf503wy6km0ad6akdvss9w5b1k3jqizy5gah1fkirkpi";
  };
  googleapis-cpp-cmakefiles = stdenv.mkDerivation rec {
    pname = "googleapis-cpp-cmakefiles";
    version = "0.1.5";
    src = fetchFromGitHub {
      owner = "googleapis";
      repo = "cpp-cmakefiles";
      rev = "v${version}";
      sha256 = "02zkcq2wl831ayd9qy009xvfx7q80pgycx7mzz9vknwd0nn6dd0n";
    };

    nativeBuildInputs = [ cmake pkg-config ];
    buildInputs = [ grpc openssl protobuf ];

    postPatch = ''
      sed -e 's,https://github.com/googleapis/googleapis/archive/9c9f778aedde02f9826d2ae5d0f9c96409ba0f25.tar.gz,file://${googleapis},' \
      -i CMakeLists.txt
    '';
  };
  _nlohmann_json = fetchurl {
    url = "https://github.com/nlohmann/json/releases/download/v3.4.0/json.hpp";
    sha256 = "0pw3jpi572irbp2dqclmyhgic6k9rxav5mpp9ygbp9xj48gnvnk3";
  };
in stdenv.mkDerivation rec {
  pname = "google-cloud-cpp";
  version = "0.14.0";

  src = fetchFromGitHub {
    owner = "googleapis";
    repo = "google-cloud-cpp";
    rev = "v${version}";
    sha256 = "15wci4m8h6py7fqfziq8mp5m6pxp2h1cbh5rp2k90mk5js4jb9pa";
  };

  buildInputs = [ curl crc32c googleapis-cpp-cmakefiles grpc protobuf libnsl ];
  nativeBuildInputs = [ clang-tools cmake pkg-config doxygen ];

  outputs = [ "out" "dev" ];

  postPatch = ''
    sed -e 's,https://github.com/nlohmann/json/releases/download/v3.4.0/json.hpp,file://${_nlohmann_json},' \
    -i cmake/DownloadNlohmannJson.cmake
  '';

  cmakeFlags = [
    "-DBUILD_SHARED_LIBS:BOOL=ON"
  ];

  meta = with lib; {
    license = with licenses; [ asl20 ];
    homepage = "https://github.com/googleapis/google-cloud-cpp";
    description = "C++ Idiomatic Clients for Google Cloud Platform services";
    maintainers = with maintainers; [ ];
  };
}
