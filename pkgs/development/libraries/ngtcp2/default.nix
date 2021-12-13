{ lib, stdenv, fetchFromGitHub
, autoreconfHook, pkg-config
, cunit, file
, jemalloc, libev, nghttp3, quictls
}:

stdenv.mkDerivation rec {
  pname = "ngtcp2";
  version = "unstable-2021-11-10";

  src = fetchFromGitHub {
    owner = "ngtcp2";
    repo = pname;
    rev = "7039808c044152c14b44046468bd16249b4d7048";
    sha256 = "1cjsky24f6fazw9b1r6w9cgp09vi8wp99sv76gg2b1r8ic3hgq23";
  };

  nativeBuildInputs = [ autoreconfHook pkg-config cunit file ];
  buildInputs = [ jemalloc libev nghttp3 quictls ];

  preConfigure = ''
    substituteInPlace ./configure --replace /usr/bin/file ${file}/bin/file
  '';

  outputs = [ "out" "dev" ];

  doCheck = true;

  meta = with lib; {
    homepage = "https://github.com/ngtcp2/ngtcp2";
    description = "ngtcp2 project is an effort to implement QUIC protocol which is now being discussed in IETF QUICWG for its standardization.";
    license = licenses.mit;
    platforms = platforms.linux;
    maintainers = with maintainers; [ izorkin ];
  };
}
