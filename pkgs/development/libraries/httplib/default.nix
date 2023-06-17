{ lib
, stdenv
, fetchFromGitHub
, cmake
, openssl
}:

stdenv.mkDerivation rec {
  pname = "httplib";
  version = "0.12.5";

  src = fetchFromGitHub {
    owner = "yhirose";
    repo = "cpp-httplib";
    rev = "v${version}";
    hash = "sha256-9qCquF6DXpgtrfXVd/hc8n1Eu1nOxf/Lm+R13QI0N9Q=";
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
