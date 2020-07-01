{ stdenv, fetchFromGitHub, cmake, gmock, boost, pkgconfig, protobuf, icu }:

stdenv.mkDerivation rec {
  pname = "phonenumber";
  version = "8.11.3";

  src = fetchFromGitHub {
    owner = "googlei18n";
    repo = "libphonenumber";
    rev = "v${version}";
    sha256 = "06y3mh1d1mks6d0ynxp3980g712nkf8l5nyljpybsk326b246hg9";
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
