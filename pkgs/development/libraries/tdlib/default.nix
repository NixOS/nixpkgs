{ fetchFromGitHub, gperf, openssl, readline, zlib, cmake, stdenv }:

stdenv.mkDerivation rec {
  version = "1.4.0";
  pname = "tdlib";

  src = fetchFromGitHub {
    owner = "tdlib";
    repo = "td";
    rev = "v${version}";
    sha256 = "1ijyn14rjb87rqm39hg7md8ab33yiy8cgzw3p0m37scn58gabpp7";
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
