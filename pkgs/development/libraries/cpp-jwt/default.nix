{ lib, stdenv, fetchFromGitHub, cmake, openssl, gtest, nlohmann_json }:

stdenv.mkDerivation rec {
  pname = "cpp-jwt";
  version = "1.4";

  src = fetchFromGitHub {
    owner = "arun11299";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-5hVsFanTCT/uLLXrnb2kMvmL6qs9RXVkvxdWaT6m4mk=";
  };

  cmakeFlags = [
    "-DCPP_JWT_USE_VENDORED_NLOHMANN_JSON=OFF"
    "-DCPP_JWT_BUILD_EXAMPLES=OFF"
  ];

  nativeBuildInputs = [ cmake gtest ];

  buildInputs = [ openssl nlohmann_json ];

  doCheck = true;

  meta = {
    description = "JSON Web Token library for C++";
    homepage = "https://github.com/arun11299/cpp-jwt";
    license = lib.licenses.mit;
    maintainers = with lib.maintainers; [ fpletz ];
  };
}
