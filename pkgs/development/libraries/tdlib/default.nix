{ stdenv, fetchFromGitHub, cmake, gperf, openssl, readline, zlib }:

stdenv.mkDerivation rec {
  version = "2018-03-20";
  name = "tdlib-${version}";

  src = fetchFromGitHub {
    owner = "tdlib";
    repo = "td";
    rev = "cfe4d9bdcee9305632eb228a46a95407d05b5c7a";
    sha256 = "0445hiqp2gmkd60kcv7r10li7k09bjrzy3ywd43iwc99jay1pwc1";
  };

  buildInputs = [ gperf openssl readline zlib ];
  nativeBuildInputs = [ cmake ];

  meta = with stdenv.lib; {
    description = "Cross-platform library for building Telegram clients";
    homepage = "https://core.telegram.org/tdlib/";
    license = [ licenses.boost ];
    platforms = platforms.linux;
  };
}

