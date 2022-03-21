{ lib, stdenv, fetchFromGitHub
, autoreconfHook, pkg-config
, cunit, file, ncurses
}:

stdenv.mkDerivation rec {
  pname = "nghttp3";
  version = "unstable-2021-12-22";

  src = fetchFromGitHub {
    owner = "ngtcp2";
    repo = pname;
    rev = "8d8184acf850b06b53157bba39022bc7b7b5f1cd";
    sha256 = "sha256-pV1xdQa5RBz17jDINC2uN1Q+jpa2edDwqTqf8D5VU3E=";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config file ];
  checkInputs = [ cunit ncurses ];

  preConfigure = ''
    substituteInPlace ./configure --replace /usr/bin/file ${file}/bin/file
  '';

  outputs = [ "out" "dev" ];

  doCheck = true;
  enableParallelBuilding = true;

  meta = with lib; {
    homepage = "https://github.com/ngtcp2/nghttp3";
    description = "nghttp3 is an implementation of HTTP/3 mapping over QUIC and QPACK in C.";
    license = licenses.mit;
    platforms = platforms.unix;
    maintainers = with maintainers; [ izorkin ];
  };
}
