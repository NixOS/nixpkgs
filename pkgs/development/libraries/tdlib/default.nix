{ fetchFromGitHub, gperf, openssl, readline, zlib, cmake, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "tdlib";
  version = "1.8.1";

  src = fetchFromGitHub {
    owner = "tdlib";
    repo = "td";
    # https://github.com/tdlib/td/issues/1790
    rev = "92c2a9c4e521df720abeaa9872e1c2b797d5c93f";
    sha256 = "ZoKsgdkS78mptfbxkkV4pgcgJEaWwKZWK2cvmxgJN4E=";
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
