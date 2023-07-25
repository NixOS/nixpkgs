{ lib
, stdenv
, fetchFromGitHub
, cmake
, openssl
}:

stdenv.mkDerivation rec {
  pname = "httplib";
  version = "0.13.1";

  src = fetchFromGitHub {
    owner = "yhirose";
    repo = "cpp-httplib";
    rev = "v${version}";
    hash = "sha256-2vS8gdJrf7Iz6F5kyyWlr7zB1eBDjxdLesJcnkhg5eE=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ openssl ];

  meta = with lib; {
    description = "A C++ header-only HTTP/HTTPS server and client library";
    homepage = "https://github.com/yhirose/cpp-httplib";
    changelog = "https://github.com/yhirose/cpp-httplib/releases/tag/v${version}";
    maintainers = with maintainers; [ aidalgol ];
    license = licenses.mit;
  };
}
