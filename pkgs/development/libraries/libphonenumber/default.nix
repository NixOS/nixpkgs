{ stdenv, fetchFromGitHub, cmake, gmock, boost, pkgconfig, protobuf, icu }:

let
  version = "8.10.17";
in
stdenv.mkDerivation {
  name = "phonenumber-${version}";
  inherit version;

  src = fetchFromGitHub {
    owner = "googlei18n";
    repo = "libphonenumber";
    rev = "v${version}";
    sha256 = "0h2zkcymzbfpirccgij3dm9jzagsqzsz2mq1j13cykcxa0n8a5fb";
  };

  nativeBuildInputs = [
    cmake
    gmock
    pkgconfig
  ];

  buildInputs = [
    boost
    protobuf
    icu
  ];

  cmakeDir = "../cpp";

  checkPhase = "./libphonenumber_test";

  meta = with stdenv.lib; {
    description = "Google's i18n library for parsing and using phone numbers";
    license = licenses.asl20;
    maintainers = with maintainers; [ illegalprime ];
  };
}
