{ lib, stdenv, fetchFromGitHub, cmake, gtest, boost, pkg-config, protobuf, icu, Foundation, buildPackages }:

stdenv.mkDerivation rec {
  pname = "libphonenumber";
  version = "8.12.37";

  src = fetchFromGitHub {
    owner = "googlei18n";
    repo = "libphonenumber";
    rev = "v${version}";
    sha256 = "sha256-xLxadSxVY3DjFDQrqj3BuOvdMaKdFSLjocfzovJCBB0=";
  };

  patches = [
    # An earlier version of this patch was submitted upstream but did not get
    # any interest there - https://github.com/google/libphonenumber/pull/2921
    ./build-reproducibility.patch
  ];

  nativeBuildInputs = [
    cmake
    pkg-config
  ];

  buildInputs = [
    boost
    protobuf
    icu
    gtest
  ] ++ lib.optional stdenv.isDarwin Foundation;

  cmakeDir = "../cpp";
  cmakeFlags =
    lib.optionals (stdenv.hostPlatform != stdenv.buildPlatform) [
      "-DBUILD_GEOCODER=OFF"
      "-DPROTOC_BIN=${buildPackages.protobuf}/bin/protoc"
    ];

  checkPhase = "./libphonenumber_test";

  meta = with lib; {
    description = "Google's i18n library for parsing and using phone numbers";
    homepage = "https://github.com/google/libphonenumber";
    license = licenses.asl20;
    maintainers = with maintainers; [ illegalprime ];
  };
}
