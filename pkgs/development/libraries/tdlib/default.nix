{ fetchFromGitHub, gperf, openssl, readline, zlib, cmake, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "tdlib";
  version = "1.7.12";

  src = fetchFromGitHub {
    owner = "tdlib";
    repo = "td";
    # https://github.com/tdlib/td/issues/1790
    rev = "a69030239c53951db8a1b0af6408f24d63f5dcb7";
    sha256 = "tqytmjij79YzvBP1abbA/Oavx28mvEGESn39b3HYAMg=";
  };

  buildInputs = [ gperf openssl readline zlib ];
  nativeBuildInputs = [ cmake ];

  meta = with lib; {
    description = "Cross-platform library for building Telegram clients";
    homepage = "https://core.telegram.org/tdlib/";
    license = [ licenses.boost ];
    platforms = platforms.unix;
    maintainers = [ maintainers.vyorkin ];
  };
}
