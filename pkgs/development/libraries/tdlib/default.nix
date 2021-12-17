{ fetchFromGitHub, gperf, openssl, readline, zlib, cmake, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "tdlib";
  version = "1.7.10";

  src = fetchFromGitHub {
    owner = "tdlib";
    repo = "td";
    # https://github.com/tdlib/td/issues/1790
    rev = "a53cb30e99f937cfd64e0266fa558785a184a553";
    sha256 = "FX+66JRsigauLq2JLx0InWiedGeQJ9+ox+D/Bqik9ik=";
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
