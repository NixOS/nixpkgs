{ fetchFromGitHub, gperf, openssl, readline, zlib, cmake, stdenv }:

stdenv.mkDerivation rec {
  version = "1.6.0";
  pname = "tdlib";

  src = fetchFromGitHub {
    owner = "tdlib";
    repo = "td";
    rev = "v${version}";
    sha256 = "0zlzpl6fgszg18kwycyyyrnkm255dvc6fkq0b0y32m5wvwwl36cv";
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
