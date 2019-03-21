{ stdenv, fetchFromGitHub, autoreconfHook, libtool, openssl, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libp11-${version}";
  version = "0.4.9";

  src = fetchFromGitHub {
    owner = "OpenSC";
    repo = "libp11";
    rev = name;
    sha256 = "1f0ir1mnr4wxxnql8ld2aa6288fn04fai5pr0sics7kbdm1g0cki";
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
