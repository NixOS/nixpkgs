{ fetchFromGitHub, gperf, openssl, readline, zlib, cmake, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "tdlib";
  version = "1.7.9";

  src = fetchFromGitHub {
    owner = "tdlib";
    repo = "td";
    # https://github.com/tdlib/td/issues/1718
    rev = "7d41d9eaa58a6e0927806283252dc9e74eda5512";
    sha256 = "09b7srbfqi4gmg5pdi398pr0pxihw4d3cw85ycky54g862idzqs8";
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
