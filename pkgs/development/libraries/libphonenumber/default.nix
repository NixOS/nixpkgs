{ stdenv, fetchFromGitHub, cmake, gmock, boost, pkgconfig, protobuf, icu }:

let
  version = "8.9.9";
in
stdenv.mkDerivation {
  name = "phonenumber-${version}";
  inherit version;

  src = fetchFromGitHub {
    owner = "googlei18n";
    repo = "libphonenumber";
    rev = "v${version}";
    sha256 = "005visnfnr84blgdi0yp4hrzskwbsnawrzv6lqfi9f073l6w5j6w";
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
