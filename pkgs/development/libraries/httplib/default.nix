{ lib
, stdenv
, fetchFromGitHub
, meson
, cmake
, pkg-config
, openssl
, zlib
, brotli
, ninja
}:

stdenv.mkDerivation rec {
  pname = "httplib";
  version = "0.12.2";

  src = fetchFromGitHub {
    owner = "yhirose";
    repo = "cpp-httplib";
    rev = "v${version}";
    hash = "sha256-mpHw9fzGpYz04rgnfG/qTNrXIf6q+vFfIsjb56kJsLg=";
  };

  nativeBuildInputs = [
    meson
    cmake
    pkg-config
    ninja
  ];

  buildInputs = [
    openssl
    zlib
    brotli
  ];

  meta = with lib; {
    description = "A C++ header-only HTTP/HTTPS server and client library";
    homepage = "https://github.com/yhirose/cpp-httplib";
    changelog = "https://github.com/yhirose/cpp-httplib/releases/tag/v${version}";
    maintainers = with maintainers; [ aidalgol ];
    license = licenses.mit;
  };
}
