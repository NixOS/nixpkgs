{ lib, stdenv, fetchFromGitHub
, autoreconfHook, pkg-config
, cunit, file, ncurses
}:

stdenv.mkDerivation rec {
  pname = "nghttp3";
  version = "0.4.0";

  src = fetchFromGitHub {
    owner = "ngtcp2";
    repo = pname;
    rev = "v${version}";
    sha256 = "sha256-toGTkgJLdSLNWCPJFpT63IxF3xANbvtkhJo5NUg/ZBg=";
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
