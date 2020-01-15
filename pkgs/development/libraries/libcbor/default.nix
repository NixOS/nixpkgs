{ stdenv, fetchFromGitHub, cmake, cmocka }:

stdenv.mkDerivation rec {
  pname = "libcbor";
  version = "2019-02-23";

  src = fetchFromGitHub {
    owner = "PJK";
    repo = pname;
    rev = "87f977e732ca216682a8583a0e43803eb6b9c028";
    sha256 = "17p1ahdcpf5d4r472lhciscaqjq4pyxy9xjhqqx8mv646xmyripm";
  };

  nativeBuildInputs = [ cmake ];
  checkInputs = [ cmocka ];

  doCheck = false; # needs "-DWITH_TESTS=ON", but fails w/compilation error

  NIX_CFLAGS_COMPILE = [ "-fno-lto" ];

  meta = with stdenv.lib; {
    description = "CBOR protocol implementation for C and others";
    homepage = https://github.com/PJK/libcbor;
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
