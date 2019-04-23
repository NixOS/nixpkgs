{ stdenv, fetchFromGitHub, autoreconfHook, libtool, openssl, pkgconfig }:

stdenv.mkDerivation rec {
  name = "libp11-${version}";
  version = "0.4.10";

  src = fetchFromGitHub {
    owner = "OpenSC";
    repo = "libp11";
    rev = name;
    sha256 = "1m4aw45bqichhx7cn78d8l1r1v0ccvwzlfj09fay2l9rfic5jgfz";
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
