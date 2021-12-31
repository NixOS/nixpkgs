{ fetchFromGitHub, gperf, openssl, readline, zlib, cmake, lib, stdenv }:

stdenv.mkDerivation rec {
  pname = "tdlib";
  version = "1.8.0";

  src = fetchFromGitHub {
    owner = "tdlib";
    repo = "td";
    # https://github.com/tdlib/td/issues/1790
    rev = "b3ab664a18f8611f4dfcd3054717504271eeaa7a";
    sha256 = "OBgzFBi+lIBbKnHDm5D/F3Xi4s1x4geb+1OoBP3F+qY=";
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
