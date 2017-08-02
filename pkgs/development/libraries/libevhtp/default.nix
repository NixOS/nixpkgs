{ stdenv, fetchFromGitHub, cmake, openssl, libevent }:

stdenv.mkDerivation rec {
  name = "libevhtp-${version}";
  version = "1.2.11";

  src = fetchFromGitHub {
    owner = "ellzey";
    repo = "libevhtp";
    rev = version;
    sha256 = "1rlxdp8w4alcy5ryr7pmw5wi6hv7d64885wwbk1zxhvi64s4x4rg";
  };

  buildInputs = [ cmake openssl libevent ];

  buildPhase = "cmake";

  meta = with stdenv.lib; {
    description = "A more flexible replacement for libevent's httpd API";
    homepage = https://github.com/ellzey/libevhtp;
    license = licenses.bsd3;
    maintainers = with maintainers; [ edwtjo ];
    platforms = platforms.linux;
  };
}
