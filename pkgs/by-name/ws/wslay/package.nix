{ stdenv, lib, fetchFromGitHub, cmake, cunit }:

stdenv.mkDerivation rec {
  pname = "wslay";
  version = "1.1.1";

  src = fetchFromGitHub {
    owner = "tatsuhiro-t";
    repo = "wslay";
    rev = "release-${version}";
    hash = "sha256-xKQGZO5hNzMg+JYKeqOBsu73YO+ucBEOcNhG8iSNYvA=";
  };

  checkInputs = [ cunit ];
  doCheck = true;

  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    homepage = "https://tatsuhiro-t.github.io/wslay/";
    description = "The WebSocket library in C";
    license = with licenses; [ mit ];
    maintainers = with maintainers; [ pingiun ];
    platforms = platforms.unix;
  };
}
