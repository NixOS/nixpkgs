{ lib, stdenv, fetchFromGitHub, cmake, cmocka }:

stdenv.mkDerivation rec {
  pname = "libcbor";
  version = "0.8.0";

  src = fetchFromGitHub {
    owner = "PJK";
    repo = pname;
    rev = "v${version}";
    sha256 = "01dv4vxcmbvpphqy16vqiwh25wx11x630js5wfnx7cryarsh9ld7";
  };

  nativeBuildInputs = [ cmake ];
  checkInputs = [ cmocka ];

  doCheck = false; # needs "-DWITH_TESTS=ON", but fails w/compilation error

  cmakeFlags = [ "-DCMAKE_INSTALL_LIBDIR=lib" "-DBUILD_SHARED_LIBS=on" ];

  meta = with lib; {
    description = "CBOR protocol implementation for C and others";
    homepage = "https://github.com/PJK/libcbor";
    license = licenses.mit;
    maintainers = with maintainers; [ dtzWill ];
  };
}
