{ fetchFromGitHub, gperf, openssl, readline, zlib, cmake, lib, stdenv }:

stdenv.mkDerivation rec {
  version = "1.7.0";
  pname = "tdlib";

  src = fetchFromGitHub {
    owner = "tdlib";
    repo = "td";

    rev = "v${version}";

    sha256 = "sha256-sZzp9k7KDnqftcSGSgXkIy0siCksGPBmRckySU/J0TU=";
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
