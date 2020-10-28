{ fetchFromGitHub, gperf, openssl, readline, zlib, cmake, stdenv }:

stdenv.mkDerivation rec {
  version = "1.6.9";
  pname = "tdlib";

  src = fetchFromGitHub {
    owner = "tdlib";
    repo = "td";
    rev = "32f2338bd199dd06a1b4b5f1ad14f2d4f2868f01";
    sha256 = "0wv03hlgzrsc04kcwnwz6dsmkdzvhb0i1wjs08gzivwxw06pkq4n";
  };

  buildInputs = [ gperf openssl readline zlib ];
  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "Cross-platform library for building Telegram clients";
    homepage = "https://core.telegram.org/tdlib/";
    license = [ licenses.boost ];
    platforms = platforms.unix;
    maintainers = [ maintainers.vyorkin ];
  };
}
