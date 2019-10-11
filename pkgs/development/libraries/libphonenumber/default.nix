{ stdenv, fetchFromGitHub, cmake, gmock, boost, pkgconfig, protobuf, icu }:

stdenv.mkDerivation rec {
  pname = "phonenumber";
  version = "8.10.20";

  src = fetchFromGitHub {
    owner = "googlei18n";
    repo = "libphonenumber";
    rev = "v${version}";
    sha256 = "12xszrd4mrjabhzsp0xvy2qx2rxl36y5a00xfsh0w7bc299rq13v";
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
