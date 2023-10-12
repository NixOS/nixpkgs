{ lib
, stdenv
, fetchFromGitHub
, cmake
, openssl
}:

stdenv.mkDerivation rec {
  pname = "httplib";
  version = "0.14.1";

  src = fetchFromGitHub {
    owner = "yhirose";
    repo = "cpp-httplib";
    rev = "v${version}";
    hash = "sha256-JBs2FvcdAvxysYhzakP0wU/mUCWfKZ8dk5ROWL5sej0=";
  };

  nativeBuildInputs = [ cmake ];
  buildInputs = [ openssl ];

  meta = with lib; {
    description = "A C++ header-only HTTP/HTTPS server and client library";
    homepage = "https://github.com/yhirose/cpp-httplib";
    changelog = "https://github.com/yhirose/cpp-httplib/releases/tag/v${version}";
    maintainers = with maintainers; [ aidalgol ];
    license = licenses.mit;
    platforms = platforms.all;
  };
}
