{ stdenv, fetchFromGitHub, autoreconfHook, libtool, openssl, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libp11-${version}";
  version = "0.4.7";

  src = fetchFromGitHub {
    owner = "OpenSC";
    repo = "libp11";
    rev = name;
    sha256 = "0n1i0pxj6l0vdq8gpdwfp5p9qd7wkymg0lpy6a17ix8hpqsljlhr";
  };

  makeFlags = [ "DESTDIR=$(out)" "PREFIX=" ];

  nativeBuildInputs = [ autoreconfHook pkgconfig libtool ];
  buildInputs = [ openssl ];

  meta = with stdenv.lib; {
    homepage = https://github.com/OpenSC/libp11;
    license = licenses.lgpl21Plus;
    description = "Small layer on top of PKCS#11 API to make PKCS#11 implementations easier";
    platforms = platforms.all;
  };
}
