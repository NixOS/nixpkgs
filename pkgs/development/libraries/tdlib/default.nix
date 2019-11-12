{ fetchFromGitHub, gperf, openssl, readline, zlib, cmake, stdenv }:

stdenv.mkDerivation rec {
  version = "1.5.0";
  pname = "tdlib";

  src = fetchFromGitHub {
    owner = "tdlib";
    repo = "td";
    rev = "v${version}";
    sha256 = "1rqxdvzlryqln5jzj35cwz1fjwy4s8xq97p0wdnpzbfjpcalvrm5";
  };

  buildInputs = [ gperf openssl readline zlib ];
  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "Cross-platform library for building Telegram clients";
    homepage = "https://core.telegram.org/tdlib/";
    license = [ licenses.boost ];
    platforms = platforms.linux;
    maintainers = [ maintainers.vyorkin ];
  };
}
