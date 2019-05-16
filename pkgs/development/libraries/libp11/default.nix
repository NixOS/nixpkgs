{ stdenv, fetchFromGitHub, autoreconfHook, libtool, pkgconfig
, openssl }:

stdenv.mkDerivation rec {
  name = "libp11-${version}";
  version = "0.4.10";

  src = fetchFromGitHub {
    owner = "OpenSC";
    repo = "libp11";
    rev = name;
    sha256 = "1m4aw45bqichhx7cn78d8l1r1v0ccvwzlfj09fay2l9rfic5jgfz";
  };

  configureFlags = [
    "--with-enginesdir=${placeholder "out"}/lib/engines"
  ];

  nativeBuildInputs = [ autoreconfHook pkgconfig libtool ];

  buildInputs = [ openssl ];

  enableParallelBuilding = true;

  meta = with stdenv.lib; {
    description = "Small layer on top of PKCS#11 API to make PKCS#11 implementations easier";
    homepage = https://github.com/OpenSC/libp11;
    license = licenses.lgpl21Plus;
    platforms = platforms.all;
  };
}
