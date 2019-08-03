{ stdenv, fetchurl, pkgconfig }:

stdenv.mkDerivation rec{
  name = "libqb-0.17.2";

  src = fetchurl {
    url = "https://fedorahosted.org/releases/q/u/quarterback/${name}.tar.xz";
    sha256 = "1zpl45p3n6dn1jgbsrrmccrmv2mvp8aqmnl0qxfjf7ymkrj9qhcs";
  };

  nativeBuildInputs = [ pkgconfig ];

  meta = with stdenv.lib; {
    homepage = https://github.com/clusterlabs/libqb;
    description = "A library providing high performance logging, tracing, ipc, and poll";
    license = licenses.lgpl21;
    platforms = platforms.unix;
  };
}
