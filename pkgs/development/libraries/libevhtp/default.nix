{ stdenv, fetchFromGitHub, cmake, openssl, libevent }:

stdenv.mkDerivation rec {
  name = "libevhtp-${version}";
  version = "1.2.10";

  src = fetchFromGitHub {
    owner = "ellzey";
    repo = "libevhtp";
    rev = version;
    sha256 = "0z5cxa65zp89vkaj286gp6fpmc5fylr8bmd17g3j1rgc42nysm6a";
  };

  buildInputs = [ cmake openssl libevent ];

  buildPhase = "cmake";

  meta = with stdenv.lib; {
    description = "A more flexible replacement for libevent's httpd API";
    homepage = "https://github.com/ellzey/libevhtp";
    license = licenses.bsd3;
    maintainers = with maintainers; [ edwtjo ];
    platforms = platforms.linux;
  };
}
