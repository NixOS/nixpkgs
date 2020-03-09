{ stdenv, fetchFromGitHub, cmake, cmocka }:

stdenv.mkDerivation rec {
  pname = "libcbor";
  version = "unstable-2019-07-25";

  src = fetchFromGitHub {
    owner = "PJK";
    repo = pname;
    rev = "82512d851205fbc7f65d96a0b4a8e1bad2e4f3c6";
    sha256 = "01hy7n21gxz4gp3gdwm2ywz822p415bj2k9ccxgwz3plvncs4xa1";
  };

  nativeBuildInputs = [ cmake ];
  checkInputs = [ cmocka ];

  doCheck = false; # needs "-DWITH_TESTS=ON", but fails w/compilation error

  NIX_CFLAGS_COMPILE = "-fno-lto";

  meta = with stdenv.lib; {
    description = "CBOR protocol implementation for C and others";
    homepage = https://github.com/PJK/libcbor;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
