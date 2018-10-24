{ stdenv, fetchFromGitHub, cmake, openssl }:

stdenv.mkDerivation rec {
  name = "libsignal-protocol-c";
  version = "2.3.2";

  src = fetchFromGitHub {
    owner = "signalapp";
    repo = "libsignal-protocol-c";
    rev = "v${version}";
    sha256 = "1qj2w4csy6j9jg1jy66n1qwysx7hgjywk4n35hlqcnh1kpa14k3p";
  };

  nativeBuildInputs = [ cmake ];

  buildInputs = [ openssl ];

  cmakeFlags = [ "-DBUILD_SHARED_LIBS=ON" ];

  outputs = [ "out" "dev" ];

  meta = with stdenv.lib; {
    description = "Signal Protocol C Library";
    homepage = https://github.com/signalapp/libsignal-protocol-c;
    license = licenses.gpl3;
    platforms = platforms.all;
    maintainers = with maintainers; [ orivej ];
  };
}
