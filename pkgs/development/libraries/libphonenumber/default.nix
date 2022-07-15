{ lib
, stdenv
, fetchFromGitHub
, cmake
, pkg-config
, git
, gtest
, abseil-cpp
, boost
, protobuf
, Foundation
, icu
}:

stdenv.mkDerivation rec {
  pname = "phonenumber";
  version = "8.12.51";

  src = fetchFromGitHub {
    owner = "google";
    repo = "libphonenumber";
    rev = "v${version}";
    hash = "sha256-b03GYBepvQBcTJDg+HsOKbykHpQ8hpHGL5pbeX5jnms=";
  };

  patches = [
    ./cmake-abseil.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
    gtest
  ];

  buildInputs = [
    boost
  ] ++ lib.optionals stdenv.isDarwin [
    Foundation
  ];

  propagatedBuildInputs = [
    abseil-cpp
    icu
    protobuf
  ];

  cmakeDir = "../cpp";

  doCheck = true;

  checkTarget = "tests";

  meta = with lib; {
    description = "Google's i18n library for parsing and using phone numbers";
    homepage = "https://github.com/google/libphonenumber";
    license = licenses.asl20;
    maintainers = with maintainers; [ illegalprime ];
  };
}
